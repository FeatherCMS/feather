import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AuthAdminAPI

@testable import Server

@Suite
struct AdminAPIUserMagicLinkSearchTests {

    @Test
    func searchMagicLinksIsOkForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "auth:magic-links:create",
            "auth:magic-links:list",
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
            let _ = try await response.json(
                status: .created,
                Components.Schemas.AuthMagicLinkDetailSchema.self
            )
        }

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/magic-links/search",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.AuthMagicLinkListItemSearchQuerySchema(
                    page: .init(size: 10, number: 1),
                    sort: [],
                    filters: .init(search: nil)
                )
            )
        ) { response in
            let object = try await response.json(
                status: .ok,
                Components.Schemas.AuthMagicLinkListItemSearchSchema.self
            )
            #expect(object.data.total >= 1)
        }
    }
}
