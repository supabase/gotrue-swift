import XCTest

@testable import GoTrue

final class GoTrueTests: XCTestCase {

  func testDecode() {
    XCTAssertNoThrow(
      try JSONDecoder.goTrue.decode(
        SessionOrUser.self, from: sessionJSON.data(using: .utf8)!)
    )
  }
}

let sessionJSON = """
  {
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNjQ4NjQwMDIxLCJzdWIiOiJmMzNkM2VjOS1hMmVlLTQ3YzQtODBlMS01YmQ5MTlmM2Q4YjgiLCJlbWFpbCI6Imd1aWxoZXJtZTJAZ3Jkcy5kZXYiLCJwaG9uZSI6IiIsImFwcF9tZXRhZGF0YSI6eyJwcm92aWRlciI6ImVtYWlsIiwicHJvdmlkZXJzIjpbImVtYWlsIl19LCJ1c2VyX21ldGFkYXRhIjp7fSwicm9sZSI6ImF1dGhlbnRpY2F0ZWQifQ.4lMvmz2pJkWu1hMsBgXP98Fwz4rbvFYl4VA9joRv6kY",
  "token_type": "bearer",
  "expires_in": 3600,
  "refresh_token": "GGduTeu95GraIXQ56jppkw",
  "user": {
  "id": "f33d3ec9-a2ee-47c4-80e1-5bd919f3d8b8",
  "aud": "authenticated",
  "role": "authenticated",
  "email": "guilherme2@grds.dev",
  "email_confirmed_at": "2022-03-30T10:33:41.018575157Z",
  "phone": "",
  "last_sign_in_at": "2022-03-30T10:33:41.021531328Z",
  "app_metadata": {
  "provider": "email",
  "providers": [
  "email"
  ]
  },
  "user_metadata": {},
  "identities": [
  {
  "id": "f33d3ec9-a2ee-47c4-80e1-5bd919f3d8b8",
  "user_id": "f33d3ec9-a2ee-47c4-80e1-5bd919f3d8b8",
  "identity_data": {
    "sub": "f33d3ec9-a2ee-47c4-80e1-5bd919f3d8b8"
  },
  "provider": "email",
  "last_sign_in_at": "2022-03-30T10:33:41.015557063Z",
  "created_at": "2022-03-30T10:33:41.015612Z",
  "updated_at": "2022-03-30T10:33:41.015616Z"
  }
  ],
  "created_at": "2022-03-30T10:33:41.005433Z",
  "updated_at": "2022-03-30T10:33:41.022688Z"
  }
  }
  """
