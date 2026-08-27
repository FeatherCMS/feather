import AccountAdminAPI
import AccountAppAPI
import AuthAppAPI
import FeatherHTTP
import Foundation
import HTTPTypes
import OpenAPIRuntime
import Testing

@testable import Server

@Suite
struct AppAPIAccountInvitationAcceptanceTests {

    @Test
    func invitationCanBeValidatedExchangedAndUsedForLogin() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "account:invitations:create"
        ])
        let adminToken = try await runner.authenticateTestAccount()
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
                    email: email
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
