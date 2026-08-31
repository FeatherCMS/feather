import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AccountAdminAPI

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@testable import Server

@Suite
struct AdminAPIAccountInvitationDeleteTests {

    @Test
    func deleteAccountInvitationIsNoContentForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "account:invitations:create",
            "account:invitations:delete",
        ])
        let token = try await runner.authenticateTestAccount()

        let created = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/account/invitations",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.AccountInvitationCreateSchema(
                    email:
                        "inv-\(UUID().uuidString.lowercased())@example.com"
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.AccountInvitationDetailSchema.self
            )
        }

        try await runner.run(
            request: JSONRequest(
                method: .delete,
                path: "/api/v1/admin/account/invitations",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.BulkDeleteRequestSchema(
                    ids: [created.id],
                    summary: true
                )
            )
        ) { response in
            #expect(response.response.status == .ok)
        }
    }
}
