import AccountAdminAPI
import UserAdminAPI
import FeatherHTTP
import Foundation
import HTTPTypes
import OpenAPIRuntime
import Testing

@testable import Server

@Suite
struct AdminAPIAccountInvitationResendTests {

    @Test
    func patchAccountInvitationPersistsRoleIDs() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "account:invitations:create",
            "account:invitations:update",
            "user:roles:create"
        ])
        let token = try await runner.authenticateTestAccount()
        let role = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/roles",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(token: token)
                ],
                body: UserAdminAPI.Components.Schemas.UserRoleCreateSchema(
                    id: "patch-role-\(UUID().uuidString.lowercased())",
                    name: "Patch invitation role",
                    notes: nil
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                UserAdminAPI.Components.Schemas.UserRoleDetailSchema.self
            )
        }
        let invitation = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/account/invitations",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(token: token)
                ],
                body: Components.Schemas.AccountInvitationCreateSchema(
                    email: "patch-\(UUID().uuidString)@example.com"
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.AccountInvitationDetailSchema.self
            )
        }

        let updated = try await runner.run(
            request: JSONRequest(
                method: .patch,
                path: "/api/v1/admin/account/invitations/\(invitation.id)",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(token: token)
                ],
                body: Components.Schemas.AccountInvitationPatchSchema(
                    email: nil,
                    roleIds: [role.id]
                )
            )
        ) { response in
            try await response.json(
                status: .ok,
                Components.Schemas.AccountInvitationDetailSchema.self
            )
        }

        #expect(updated.roleIds == [role.id])
    }

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

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/account/invitations/missing-invitation/resend",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(token: token)
                ],
                body: [String: String]()
            )
        ) { response in
            #expect(response.response.status == .notFound)
        }

        try await runner.run(
            request: JSONRequest(
                method: .get,
                path: "/api/v1/account/invitation/exchange?token=\(invitation.token)",
                body: [String: String]()
            )
        ) { response in
            #expect(response.response.status == .notFound)
        }

    }
}
