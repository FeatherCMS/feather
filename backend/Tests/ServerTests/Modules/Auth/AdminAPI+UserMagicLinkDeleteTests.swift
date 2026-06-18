import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AdminOpenAPI

@testable import Server

@Suite
struct AdminAPIUserMagicLinkDeleteTests {

    @Test
    func deleteMagicLinkIsNoContentForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "auth:magic-links:create",
            "auth:magic-links:delete",
        ])
        let token = try await runner.authenticateTestAccount()

        let detail = try await runner.run(
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
            try await response.json(
                status: .created,
                Components.Schemas.UserMagicLinkDetailSchema.self
            )
        }

        try await runner.run(
            request: Request(
                method: .delete,
                path: "/api/v1/admin/user/magic-links/\(detail.id)",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ]
            )
        ) { response in
            #expect(response.response.status == .noContent)
        }
    }
}
