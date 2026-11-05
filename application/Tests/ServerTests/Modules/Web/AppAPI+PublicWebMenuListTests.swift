import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AuthAppAPI
import WebAppAPI

@testable import Server

@Suite
struct AppAPIPublicWebMenuListTests {

    @Test
    func anonymousUsersGetPublicMenuItems() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()

        let response = try await runner.run(
            request: JSONRequest(
                method: .get,
                path: "/api/v1/web/menus/main",
                body: ""
            )
        ) { response -> WebAppAPI.Components.Schemas.MenuSchema in
            try await response.json(
                status: .ok,
                WebAppAPI.Components.Schemas.MenuSchema.self
            )
        }

        #expect(response.key == "main")
        #expect(response.items.count == 3)
    }

    @Test
    func missingMenuKeyReturnsNotFound() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()

        try await runner.run(
            request: JSONRequest(
                method: .get,
                path: "/api/v1/web/menus/unknown",
                body: ""
            )
        ) { response in
            #expect(response.status == .notFound)
        }
    }

    @Test
    func authenticatedUsersGetMenuItems() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()

        let token = try await runner.authenticateTestAccount()
        let response = try await runner.run(
            request: JSONRequest(
                method: .get,
                path: "/api/v1/web/menus",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: ""
            )
        ) { response -> WebAppAPI.Components.Schemas.MenuListSchema in
            try await response.json(
                status: .ok,
                WebAppAPI.Components.Schemas.MenuListSchema.self
            )
        }

        let menu = try #require(response.first(where: { $0.key == "main" }))
        #expect(menu.items.count == 3)
    }
}
