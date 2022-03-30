import ComposableKeychain
import Foundation
import GoTrueHTTP
import KeychainAccess

struct SessionNotFound: Error {}

struct StoredSession: Codable {
  var session: Session
  var expirationDate: Date

  var isValid: Bool {
    expirationDate > Date().addingTimeInterval(-60)
  }

  init(session: Session, expirationDate: Date? = nil) {
    self.session = session
    self.expirationDate = expirationDate ?? Date().addingTimeInterval(session.expiresIn)
  }
}

actor SessionManager {
  typealias SessionRefresher = (_ refreshToken: String) async throws -> Session

  private let keychain: KeychainClient
  private let sessionRefresher: SessionRefresher
  private var task: Task<Session, Error>?

  init(
    serviceName: String? = nil,
    accessGroup: String? = nil,
    sessionRefresher: @escaping SessionRefresher
  ) {
    keychain = KeychainClient.live(
      keychain: accessGroup.map { Keychain(service: serviceName ?? "", accessGroup: $0) }
        ?? Keychain(service: serviceName ?? "supabase.gotrue.swift")
    )
    self.sessionRefresher = sessionRefresher
  }

  func session() async throws -> Session {
    if let task = task {
      return try await task.value
    }

    guard let currentSession = try keychain.getSession() else {
      throw SessionNotFound()
    }

    if currentSession.isValid {
      return currentSession.session
    }

    self.task = Task {
      defer { self.task = nil }

      let session = try await sessionRefresher(currentSession.session.refreshToken)
      try update(session)
      return session
    }

    return try await task!.value
  }

  func update(_ session: Session) throws {
    try keychain.storeSession(StoredSession(session: session))
  }

  func remove() {
    keychain.deleteSession()
  }

  /// Returns the currently stored session without checking if it's still valid.
  nonisolated var storedSession: Session? {
    try? keychain.getSession()?.session
  }
}

extension KeychainClient.Key {
  static var session = Self("supabase.session")
  static var expirationDate = Self("supabase.session.expiration_date")
}

extension KeychainClient {
  func getSession() throws -> StoredSession? {
    try getData(.session).flatMap {
      try JSONDecoder().decode(StoredSession.self, from: $0)
    }
  }

  func storeSession(_ session: StoredSession) throws {
    try setData(JSONEncoder().encode(session), .session)
  }

  func deleteSession() {
    try? remove(.session)
  }
}
