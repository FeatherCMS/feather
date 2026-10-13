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
struct AdminAPIAccountInvitationSearchTests {

    @Test
    func searchAccountInvitationsIsOkForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "account:invitations:create",
            "account:invitations:list",
        ])
        let token = try await runner.authenticateTestAccount()

        let _ = try await runner.run(
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
                method: .post,
                path: "/api/v1/admin/account/invitations/search",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas
                    .AccountInvitationListItemSearchQuerySchema(
                        page: .init(size: 10, number: 1),
                        sort: [],
                        filters: .init(search: nil)
                    )
            )
        ) { response in
            let object = try await response.json(
                status: .ok,
                Components.Schemas.AccountInvitationListItemSearchSchema.self
            )
            #expect(object.data.total >= 1)
        }
    }
}
