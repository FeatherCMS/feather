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
struct AdminAPIUserIdentityDeleteTests {

    @Test
    func deleteUserIdentityIsNoContentForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "user:accounts:create",
            "user:accounts:delete",
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

        try await runner.run(
            request: Request(
                method: .delete,
                path: "/api/v1/admin/user/identities/\(created.id)",
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
