import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AdminOpenAPI

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@testable import Server

@Suite
struct AdminAPIUserAccountSearchTests {

    @Test
    func searchUserAccountsIsOkForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "user:accounts:create",
            "user:accounts:list",
        ])
        let token = try await runner.authenticateTestAccount()

        let _ = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/accounts",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.UserAccountCreateSchema(
                    email:
                        "acc-\(UUID().uuidString.lowercased())@example.com",
                    password: "very-secure-password"
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.UserAccountDetailSchema.self
            )
        }

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/accounts/search",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.UserAccountListItemSearchQuerySchema(
                    page: .init(size: 10, number: 1),
                    sort: [],
                    filters: .init(search: nil)
                )
            )
        ) { response in
            let object = try await response.json(
                status: .ok,
                Components.Schemas.UserAccountListItemSearchSchema.self
            )
            #expect(object.data.total >= 1)
        }
    }
}
