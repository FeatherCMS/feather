import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AdminOpenAPI

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
                path: "/api/v1/admin/user/magic-links",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.UserMagicLinkCreateSchema(
                    email: "user@example.com",
                    isPersistent: true
                )
            )
        ) { response in
            let object = try await response.json(
                status: .created,
                Components.Schemas.UserMagicLinkDetailSchema.self
            )
            #expect(object.email == "user@example.com")
            #expect(!object.token.isEmpty)
        }
    }
}
