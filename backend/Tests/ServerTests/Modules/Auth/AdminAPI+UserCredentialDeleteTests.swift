import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AdminOpenAPI

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
        let accountID = try await runner.accountID(
            token: authentication
        )

        let created = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/credential",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: authentication
                    )
                ],
                body: Components.Schemas.UserCredentialCreateSchema(
                    accountID: accountID,
                    email: "credential-delete@example.com",
                    password: "very-secure-password"
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.UserCredentialDetailSchema.self
            )
        }

        try await runner.run(
            request: Request(
                method: .delete,
                path: "/api/v1/admin/user/credential/\(created.id)",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: authentication
                    )
                ]
            )
        ) { response in
            #expect(response.response.status == .noContent)
        }
    }
}
