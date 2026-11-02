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
            "auth:email:list",
            "user:accounts:create",
            "auth:credential:create",
            "auth:magic-links:create",
            "auth:magic-links:delete",
        ])
        let token = try await runner.authenticateTestAccount()
        let identityID = try await runner.createTestIdentity(token: token)
        let email = "user@example.com"
        _ = try await runner.createTestCredential(
            token: token,
            userId: identityID,
            email: email
        )
        let emails = try await runner.run(
            request: JSONRequest(
                method: .get,
                path: "/api/v1/admin/auth/emails",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: [String: String]()
            )
        ) { response in
            try await response.json(
                status: .ok,
                [Components.Schemas.AuthEmailSchemasDetail].self
            )
        }
        guard let emailID = emails.first(where: { $0.email == email })?.id
        else {
            throw ResponseContextError(message: "Test email was not listed")
        }

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
                    credentialId: emailID,
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
            request: JSONRequest(
                method: .delete,
                path: "/api/v1/admin/auth/magic-links",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.DeleteRequestSchema(
                    ids: [detail.id]
                )
            )
        ) { response in
            #expect(response.response.status == .noContent)
        }
    }
}
