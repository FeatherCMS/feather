import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AdminOpenAPI

@testable import Server

@Suite
struct AdminAPISystemPermissionCreateTests {

    @Test
    func createSystemPermissionIsCreatedForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "system:permissions:create"
        ])
        let token = try await runner.authenticateTestAccount()

        let name = "system.permissions.example"
        let notes = "example notes"

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
                    name: name,
                    notes: notes
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.SystemPermissionDetailSchema.self
            )
        }
        #expect(created.name == name)
    }
}
