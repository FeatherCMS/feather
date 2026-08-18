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
struct AdminAPIUserIdentityCreateTests {

    @Test
    func createUserIdentityIsCreatedForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "user:accounts:create"
        ])
        let token = try await runner.authenticateTestAccount()

        let created = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/identities",
                headerFields: [
                    .accept: "application/json",
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    ),
                ],
                body: Components.Schemas.UserIdentityCreateSchema(
                    status: .invited
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.UserIdentityDetailSchema.self
            )
        }
        #expect(!created.id.isEmpty)
    }

    @Test
    func createUserIdentityWithDefaultStatus() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "user:accounts:create"
        ])
        let token = try await runner.authenticateTestAccount()

        let created = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/identities",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.UserIdentityCreateSchema(
                    status: .invited
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.UserIdentityDetailSchema.self
            )
        }

        #expect(!created.id.isEmpty)
        #expect(created.status == .invited)
    }
}
