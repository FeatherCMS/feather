import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import UserAdminAPI

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@testable import Server

@Suite
struct AdminAPIUserIdentityCreateTests {

    @Test
    func createUserIdentityIsCreatedForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "user:accounts:create"
        ])
        let token = try await runner.authenticateTestAccount()

        let created = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/identities",
                headerFields: [
                    .accept: "application/json",
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    ),
                ],
                body: Components.Schemas.UserIdentityCreateSchema(
                    email:
                        "acc-\(UUID().uuidString.lowercased())@example.com",
                    password: "very-secure-password"
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.UserIdentityDetailSchema.self
            )
        }
        #expect(!created.id.isEmpty)
    }

    @Test
    func createUserIdentityRejectsShortPassword() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "user:accounts:create"
        ])
        let token = try await runner.authenticateTestAccount()

        let error = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/identities",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.UserIdentityCreateSchema(
                    email:
                        "acc-\(UUID().uuidString.lowercased())@example.com",
                    password: "Test123"
                )
            )
        ) { response in
            try await response.json(
                status: .badRequest,
                ErrorResponseBody.self
            )
        }

        #expect(error.code == 400)
        #expect(error.message == "Password is too short.")
        #expect(error.reason == "passwordTooShort")
    }
}

private struct ErrorResponseBody: Codable {
    let code: Int
    let message: String
    let reason: String
}
