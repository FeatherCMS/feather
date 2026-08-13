import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import UserAdminAPI

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@testable import Server

@Suite
struct AdminAPIUserIdentitySearchTests {

    @Test
    func searchUserIdentitiesIsOkForAuthorizedUser() async throws {
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
                path: "/api/v1/admin/user/identities",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.UserIdentityCreateSchema(
                    email:
                        "acc-\(UUID().uuidString.lowercased())@example.com",
                    password: "very-secure-password"
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.UserIdentityDetailSchema.self
            )
        }

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/identities/search",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.UserIdentityListItemSearchQuerySchema(
                    page: .init(size: 10, number: 1),
                    sort: [],
                    filters: .init(search: nil)
                )
            )
        ) { response in
            let object = try await response.json(
                status: .ok,
                Components.Schemas.UserIdentityListItemSearchSchema.self
            )
            #expect(object.data.total >= 1)
        }
    }
}
