import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AuthAdminAPI

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@testable import Server

@Suite
struct AdminAPIUserCredentialCreateTests {

    @Test
    func createCredentialIsCreatedForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "auth:credential:create"
        ])
        let authentication = try await runner.authenticateTestAccount()
        let identityId = try await runner.identityId(
            token: authentication
        )

        let email = "credential-\(UUID().uuidString.lowercased())@example.com"
        let credential = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/credentials",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: authentication
                    )
                ],
                body: Components.Schemas.AuthCredentialCreateSchema(
                    userId: identityId,
                    email: email,
                    password: "very-secure-password"
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.AuthCredentialDetailSchema.self
            )
        }

        #expect(!credential.id.isEmpty)
        #expect(credential.userId == identityId)
        #expect(credential.email == email)
    }
}
