import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AuthAdminAPI

@testable import Server

@Suite
struct AdminAPIUserMagicLinkDeleteTests {

    @Test
    func deleteMagicLinkIsNoContentForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "user:accounts:create",
            "auth:credential:create",
            "auth:magic-links:create",
            "auth:magic-links:delete",
        ])
        let token = try await runner.authenticateTestAccount()
        let identityID = try await runner.createTestIdentity(token: token)
        let credentialID = try await runner.createTestCredential(
            token: token,
            userId: identityID,
            email: "user@example.com"
        )

        let detail = try await runner.run(
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
            try await response.json(
                status: .created,
                Components.Schemas.AuthMagicLinkDetailSchema.self
            )
        }

        try await runner.run(
            request: Request(
                method: .delete,
                path: "/api/v1/admin/auth/magic-links",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.BulkDeleteRequestSchema(
                    ids: [detail.id],
                    summary: true
                )
            )
        ) { response in
            #expect(response.response.status == .ok)
        }
    }
}
