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
            "auth:email:list",
            "user:accounts:create",
            "auth:credential:create",
            "auth:magic-links:create",
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
                    credentialId: emailID,
                    isPersistent: true
                )
            )
        ) { response in
            let object = try await response.json(
                status: .created,
                Components.Schemas.AuthMagicLinkDetailSchema.self
            )
            #expect(object.credentialId == emailID)
            #expect(!object.token.isEmpty)
        }
    }
}
