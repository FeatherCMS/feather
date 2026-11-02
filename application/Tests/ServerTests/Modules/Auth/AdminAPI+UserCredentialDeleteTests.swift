import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AuthAdminAPI

@testable import Server

@Suite
struct AdminAPIUserCredentialDeleteTests {

    @Test
    func deleteCredentialIsNoContentForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "auth:credential:create",
            "auth:credential:delete",
        ])
        let token = try await runner.authenticateTestAccount()
        let identityId = try await runner.identityID(token: token)
        let credentialID = try await runner.createTestCredential(
            token: token,
            userId: identityId,
            email: "credential-delete@example.com"
        )

        try await runner.run(
            request: JSONRequest(
                method: .delete,
                path: "/api/v1/admin/auth/credentials",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.DeleteRequestSchema(
                    ids: [credentialID]
                )
            )
        ) { response in
            #expect(response.response.status == .noContent)
        }
    }
}
