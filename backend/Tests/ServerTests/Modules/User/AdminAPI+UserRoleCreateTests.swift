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
struct AdminAPIUserRoleCreateTests {

    @Test
    func createUserRoleIsCreatedForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "user:roles:create"
        ])
        let token = try await runner.authenticateTestAccount()

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
        #expect(!created.id.isEmpty)
    }
}
