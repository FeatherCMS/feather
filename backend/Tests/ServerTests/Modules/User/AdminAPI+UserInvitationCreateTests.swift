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
struct AdminAPIUserInvitationCreateTests {

    @Test
    func createUserInvitationIsCreatedForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "user:invitations:create"
        ])
        let token = try await runner.authenticateTestAccount()

        let created = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/invitations",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.UserInvitationCreateSchema(
                    email:
                        "inv-\(UUID().uuidString.lowercased())@example.com"
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.UserInvitationDetailSchema.self
            )
        }
        #expect(!created.id.isEmpty)
    }
}
