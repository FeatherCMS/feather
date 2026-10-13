import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AuthAdminAPI

@testable import Server

@Suite
struct AdminAPIUserMagicLinkCreateTests {

    @Test
    func createMagicLinkIsCreatedForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "user:accounts:create",
            "auth:credential:create",
            "auth:magic-links:create",
        ])
        let token = try await runner.authenticateTestAccount()
        let identityID = try await runner.createTestIdentity(token: token)
        let credentialID = try await runner.createTestCredential(
            token: token,
            userId: identityID,
            email: "user@example.com"
        )

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/magic-links",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.AuthMagicLinkCreateSchema(
                    credentialId: credentialID,
                    isPersistent: true
                )
            )
        ) { response in
            let object = try await response.json(
                status: .created,
                Components.Schemas.AuthMagicLinkDetailSchema.self
            )
            #expect(object.credentialId == credentialID)
            #expect(!object.token.isEmpty)
        }
    }
}
