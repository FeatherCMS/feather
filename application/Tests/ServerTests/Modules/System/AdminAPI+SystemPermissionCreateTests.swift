import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import SystemAdminAPI

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
                    key: name,
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

    @Test
    func invalidPermissionReturnsBadRequest() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "system:permissions:create"
        ])
        let token = try await runner.authenticateTestAccount()

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/system/permissions",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.SystemPermissionCreateSchema(
                    key: ""
                )
            )
        ) { response in
            #expect(response.response.status == .badRequest)
        }
    }

    @Test
    func unauthenticatedPermissionCreateReturnsUnauthorized() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/system/permissions",
                body: Components.Schemas.SystemPermissionCreateSchema(
                    key: "system.test.unauthenticated"
                )
            )
        ) { response in
            #expect(response.response.status == .unauthorized)
        }
    }

    @Test
    func permissionCreateWithoutPermissionReturnsForbidden() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        let token = try await runner.authenticateTestAccount()

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/system/permissions",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.SystemPermissionCreateSchema(
                    key: "system.test.forbidden"
                )
            )
        ) { response in
            #expect(response.response.status == .forbidden)
        }
    }

    @Test
    func duplicatePermissionKeyReturnsConflict() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "system:permissions:create"
        ])
        let token = try await runner.authenticateTestAccount()
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/system/permissions",
            headerFields: [
                .authorization: runner.bearerAuthorizationHeader(token: token)
            ],
            body: Components.Schemas.SystemPermissionCreateSchema(
                key: "system.test.duplicate"
            )
        )

        try await runner.run(request: request) { response in
            #expect(response.response.status == .created)
        }
        try await runner.run(request: request) { response in
            #expect(response.response.status == .conflict)
        }
    }
}
