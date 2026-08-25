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
        let authentication = try await runner.authenticateTestAccount()
        let identityId = try await runner.identityID(
            token: authentication
        )

        let created = try await runner.run(
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
                    email: "credential-delete@example.com",
                    password: "very-secure-password",
                    isPersistent: true
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.AuthCredentialDetailSchema.self
            )
        }

        try await runner.run(
            request: Request(
                method: .delete,
                path: "/api/v1/admin/auth/credentials",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: authentication
                    )
                ],
                body: Components.Schemas.BulkDeleteRequestSchema(ids: [created.id], summary: true)
            )
        ) { response in
            #expect(response.response.status == .ok)
        }
    }
}
