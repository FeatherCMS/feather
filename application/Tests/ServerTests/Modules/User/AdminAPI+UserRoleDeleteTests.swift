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
struct AdminAPIUserRoleDeleteTests {

    @Test
    func deleteUserRoleIsNoContentForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "user:roles:create",
            "user:roles:delete",
        ])
        let token = try await runner.authenticateTestAccount()
        let id = "role-\(UUID().uuidString.lowercased())"

        let created = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/roles",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.UserRoleCreateSchema(
                    id: id,
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
            request: Request(
                method: .delete,
                path: "/api/v1/admin/user/roles",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.BulkDeleteRequestSchema(ids: [created.id], summary: true)
            )
        ) { response in
            #expect(response.response.status == .ok)
        }
    }
}
