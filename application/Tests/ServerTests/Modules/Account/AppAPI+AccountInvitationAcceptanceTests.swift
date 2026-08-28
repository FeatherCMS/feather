import AccountAdminAPI
import AccountAppAPI
import AuthAppAPI
import FeatherHTTP
import Foundation
import HTTPTypes
import OpenAPIRuntime
import Testing
import UserAdminAPI

@testable import Server

@Suite
struct AppAPIAccountInvitationAcceptanceTests {

    @Test
    func invitationCanBeValidatedExchangedAndUsedForLogin() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "account:invitations:create",
            "user:identities:list",
            "user:roles:create",
        ])
        let adminToken = try await runner.authenticateTestAccount()

        try await runner.run(
            request: JSONRequest(
                method: .get,
                path: "/api/v1/account/invitation/exchange?token=missing-invitation-token",
                body: [String: String]()
            )
        ) { response in
            #expect(response.response.status == .notFound)
        }

        let role = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/roles",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: adminToken
                    )
                ],
                body: UserAdminAPI.Components.Schemas.UserRoleCreateSchema(
                    id: "role-\(UUID().uuidString.lowercased())",
                    name: "Invitation role",
                    notes: nil
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                UserAdminAPI.Components.Schemas.UserRoleDetailSchema.self
            )
        }
        let email = "invitation-\(UUID().uuidString.lowercased())@example.com"

        let invitation = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/account/invitations",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: adminToken
                    )
                ],
                body: AccountAdminAPI.Components.Schemas.AccountInvitationCreateSchema(
                    email: email,
                    roleIds: [role.id]
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                AccountAdminAPI.Components.Schemas.AccountInvitationDetailSchema.self
            )
        }

        let validation = try await runner.run(
            request: JSONRequest(
                method: .get,
                path: "/api/v1/account/invitation/exchange?token=\(invitation.token)",
                body: [String: String]()
            )
        ) { response in
            try await response.json(
                status: .ok,
                AccountAppAPI.Components.Schemas.AccountInvitationValidationSchema.self
            )
        }
        #expect(validation.email == email)
        #expect(invitation.roleIds == [role.id])

        let exchanged = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/account/invitation/exchange",
                body: AccountAppAPI.Components.Schemas.AccountInvitationExchangeRequestSchema(
                    token: invitation.token,
                    password: "invitation-password"
                )
            )
        ) { response in
            try await response.json(
                status: .ok,
                AccountAppAPI.Components.Schemas.AccountAuthResponseSchema.self
            )
        }

        #expect(exchanged.user.status == .active)
        #expect(exchanged.roles == [role.id])

        let users = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/identities/search",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: adminToken
                    )
                ],
                body: UserAdminAPI.Components.Schemas.UserIdentityListItemSearchQuerySchema(
                    page: .init(size: 10, number: 1),
                    sort: [],
                    filters: .init(role: "Invitation role")
                )
            )
        ) { response in
            try await response.json(
                status: .ok,
                UserAdminAPI.Components.Schemas.UserIdentityListItemSearchSchema.self
            )
        }
        #expect(users.data.items.contains { $0.id == exchanged.user.id })

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/account/invitation/exchange",
                body: AccountAppAPI.Components.Schemas.AccountInvitationExchangeRequestSchema(
                    token: invitation.token,
                    password: "invitation-password"
                )
            )
        ) { response in
            #expect(response.response.status == .notFound)
        }

        let login = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/auth/login",
                body: AuthAppAPI.Components.Schemas.AuthLoginRequestSchema(
                    email: email,
                    password: "invitation-password",
                    isPersistent: false
                )
            )
        ) { response in
            try await response.json(
                status: .ok,
                AuthAppAPI.Components.Schemas.AuthResponseSchema.self
            )
        }

        #expect(!login.token.isEmpty)
        #expect(login.user.id == exchanged.user.id)
    }
}
