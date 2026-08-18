import FeatherDatabase
import FeatherInfrastructure
import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AuthAppAPI
import WebAppAPI
import WebDomain
import WebInfrastructure

@testable import Server

@Suite
struct AppAPIPublicWebMenuListTests {

    @Test
    func anonymousUsersOnlyGetUnrestrictedMenuItems() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase { connection in
            try await insertRestrictedMenuItem(connection: connection)
        }

        let response = try await runner.run(
            request: JSONRequest(
                method: .get,
                path: "/api/v1/web/menus",
                body: ""
            )
        ) { response -> [WebAppAPI.Components.Schemas.WebMenuSchema] in
            try await response.json(
                status: .ok,
                [WebAppAPI.Components.Schemas.WebMenuSchema].self
            )
        }

        let menu = try #require(response.first(where: { $0.key == "main" }))
        #expect(menu.items.count == 4)
        #expect(
            menu.items.contains(where: { $0.label == "Root only" }) == false
        )
    }

    @Test
    func authenticatedUsersGetAuthorizedMenuItems() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase { connection in
            try await insertRestrictedMenuItem(connection: connection)
        }

        let token = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/auth/login",
                body: AuthAppAPI.Components.Schemas.AuthLoginRequestSchema(
                    email: "mail.tib@gmail.com",
                    password: "root",
                    isPersistent: true
                )
            )
        ) { response -> String in
            let body = try await response.json(
                status: .ok,
                AuthAppAPI.Components.Schemas.AuthResponseSchema.self
            )
            return body.token
        }

        let response = try await runner.run(
            request: JSONRequest(
                method: .get,
                path: "/api/v1/web/menus",
                headerFields: [
                    .authorization: "Bearer \(token)"
                ],
                body: ""
            )
        ) { response -> [WebAppAPI.Components.Schemas.WebMenuSchema] in
            try await response.json(
                status: .ok,
                [WebAppAPI.Components.Schemas.WebMenuSchema].self
            )
        }

        let menu = try #require(response.first(where: { $0.key == "main" }))
        #expect(menu.items.count == 6)
        #expect(menu.items.contains(where: { $0.label == "Root only" }))
    }

    private func insertRestrictedMenuItem(
        connection: any DatabaseConnection
    ) async throws {
        let context = DatabaseTransactionContext(
            connection: connection,
            idGenerator: NanoIDGenerator()
        )
        guard
            let menu = try await MenuDatabaseRepository(context: context)
                .find(key: "main")
        else {
            throw MissingMenuError()
        }
        _ = try await MenuItemDatabaseRepository(context: context).insert(
            .init(
                menuId: menu.id,
                label: "Root only",
                url: "/admin/",
                priority: 40,
                isBlank: false,
                permission: "system:permissions:list",
                authentication: .any,
                notes: "Restricted seeded item for tests."
            )
        )
    }
}

private struct MissingMenuError: Error {}
