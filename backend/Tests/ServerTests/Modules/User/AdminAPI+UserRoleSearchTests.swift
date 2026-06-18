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
struct AdminAPIUserRoleSearchTests {

    @Test
    func searchUserRolesIsOkForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "user:roles:create",
            "user:roles:list",
        ])
        let token = try await runner.authenticateTestAccount()

        let _ = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/roles",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.UserRoleCreateSchema(
                    name: "Role \(UUID().uuidString.prefix(8))",
                    notes: "notes"
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.UserRoleDetailSchema.self
            )
        }

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/roles/search",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.UserRoleListItemSearchQuerySchema(
                    page: .init(size: 10, number: 1),
                    sort: [],
                    filters: .init(search: nil)
                )
            )
        ) { response in
            let object = try await response.json(
                status: .ok,
                Components.Schemas.UserRoleListItemSearchSchema.self
            )
            #expect(object.data.total >= 1)
        }
    }
}
