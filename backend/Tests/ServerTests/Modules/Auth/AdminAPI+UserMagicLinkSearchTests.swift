import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AdminOpenAPI

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
            let _ = try await response.json(
                status: .created,
                Components.Schemas.UserMagicLinkDetailSchema.self
            )
        }

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/magic-links/search",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.UserMagicLinkListItemSearchQuerySchema(
                    page: .init(size: 10, number: 1),
                    sort: [],
                    filters: .init(search: nil)
                )
            )
        ) { response in
            let object = try await response.json(
                status: .ok,
                Components.Schemas.UserMagicLinkListItemSearchSchema.self
            )
            #expect(object.data.total >= 1)
        }
    }
}
