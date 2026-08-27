import AccountAdminAPI
import FeatherHTTP
import Foundation
import HTTPTypes
import OpenAPIRuntime
import Testing

@testable import Server

@Suite
struct AdminAPIAccountInvitationResendTests {

    @Test
    func resendAccountInvitationRenewsToken() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "account:invitations:create",
            "account:invitations:read",
        ])
        let token = try await runner.authenticateTestAccount()
        let invitation = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/account/invitations",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(token: token)
                ],
                body: Components.Schemas.AccountInvitationCreateSchema(
                    email: "resend-\(UUID().uuidString)@example.com"
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.AccountInvitationDetailSchema.self
            )
        }

        let resent = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/account/invitations/\(invitation.id)/resend",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(token: token)
                ],
                body: [String: String]()
            )
        ) { response in
            try await response.json(
                status: .ok,
                Components.Schemas.AccountInvitationDetailSchema.self
            )
        }

        #expect(resent.id == invitation.id)
        #expect(resent.token != invitation.token)
    }
}
