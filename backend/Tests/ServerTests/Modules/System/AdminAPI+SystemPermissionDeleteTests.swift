import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AdminOpenAPI

@testable import Server

@Suite
struct AdminAPISystemPermissionDeleteTests {

    @Test
    func deleteSystemPermissionIsNoContentForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "system:permissions:create",
            "system:permissions:delete",
        ])
        let token = try await runner.authenticateTestAccount()

        let created = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/system/permissions",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.SystemPermissionCreateSchema(
                    name: "system.permissions.example",
                    notes: "example notes"
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.SystemPermissionDetailSchema.self
            )
        }

        try await runner.run(
            request: Request(
                method: .delete,
                path: "/api/v1/admin/system/permissions/\(created.id)",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ]
            )
        ) { response in
            #expect(response.response.status == .noContent)
        }
    }
}
