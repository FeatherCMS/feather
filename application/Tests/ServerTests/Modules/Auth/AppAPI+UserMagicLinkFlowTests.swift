import AuthAdminAPI
import AuthAppAPI
import FeatherHTTP
import Foundation
import HTTPTypes
import OpenAPIRuntime
import Testing
import UserAdminAPI

@testable import Server

@Suite
struct AppAPIUserMagicLinkFlowTests {

    @Test
    func invalidMagicLinkReturnsUnauthorized() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/auth/magic-link/verify",
                body: AuthAppAPI.Components.Schemas
                    .AuthMagicLinkVerifyRequestSchema(
                        token: "invalid-magic-link-token"
                    )
            )
        ) { response in
            #expect(response.response.status == .unauthorized)
        }
    }

    @Test
    func requestedMagicLinkCanBeVerifiedOnce() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "user:accounts:create",
            "auth:credential:create",
            "auth:magic-links:list",
        ])
        let adminToken = try await runner.authenticateTestAccount()
        let identityID = try await runner.createTestIdentity(
            token: adminToken,
            status: .active
        )
        let email = "magic-\(UUID().uuidString.lowercased())@example.com"
        let credentialID = try await runner.createTestCredential(
            token: adminToken,
            userId: identityID,
            email: email,
            password: "magic-password"
        )

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/auth/magic-link",
                body: AuthAppAPI.Components.Schemas.AuthMagicLinkRequestSchema(
                    email: email,
                    isPersistent: false
                )
            )
        ) { response in
            #expect(response.response.status == .noContent)
        }

        let magicLinks = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/magic-links/search",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: adminToken
                    )
                ],
                body: AuthAdminAPI.Components.Schemas
                    .AuthMagicLinkListItemSearchQuerySchema(
                        page: .init(size: 10, number: 1),
                        sort: [],
                        filters: .init(search: credentialID)
                    )
            )
        ) { response in
            try await response.json(
                status: .ok,
                AuthAdminAPI.Components.Schemas
                    .AuthMagicLinkListItemSearchSchema.self
            )
        }
        guard let magicLink = magicLinks.data.items.first else {
            Issue.record("The requested magic link was not persisted")
            return
        }

        let authenticated = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/auth/magic-link/verify",
                body: AuthAppAPI.Components.Schemas
                    .AuthMagicLinkVerifyRequestSchema(
                        token: magicLink.token
                    )
            )
        ) { response in
            try await response.json(
                status: .ok,
                AuthAppAPI.Components.Schemas.AuthResponseSchema.self
            )
        }
        #expect(!authenticated.token.isEmpty)
        #expect(authenticated.user.id == identityID)

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/auth/magic-link/verify",
                body: AuthAppAPI.Components.Schemas
                    .AuthMagicLinkVerifyRequestSchema(
                        token: magicLink.token
                    )
            )
        ) { response in
            #expect(response.response.status == .unauthorized)
        }
    }
}
