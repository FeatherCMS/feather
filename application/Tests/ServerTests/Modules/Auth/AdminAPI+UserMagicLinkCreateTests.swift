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
            "auth:magic-links:create"
        ])
        let token = try await runner.authenticateTestAccount()

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
                    email: "user@example.com",
                    isPersistent: true
                )
            )
        ) { response in
            let object = try await response.json(
                status: .created,
                Components.Schemas.AuthMagicLinkDetailSchema.self
            )
            #expect(object.email == "user@example.com")
            #expect(!object.token.isEmpty)
        }
    }
}
