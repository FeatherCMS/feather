import FeatherDatabase
import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AppOpenAPI

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
        ) { response in
            try await response.json(
                status: .ok,
                [Components.Schemas.WebMenuSchema].self
            )
        }

        let menu = try #require(response.first(where: { $0.key == "main" }))
        #expect(menu.items.count == 3)
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
                body: Components.Schemas.AuthLoginRequestSchema(
                    email: "mail.tib@gmail.com",
                    password: "root",
                    isPersistent: true
                )
            )
        ) { response in
            let body = try await response.json(
                status: .ok,
                Components.Schemas.AuthResponseSchema.self
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
        ) { response in
            try await response.json(
                status: .ok,
                [Components.Schemas.WebMenuSchema].self
            )
        }

        let menu = try #require(response.first(where: { $0.key == "main" }))
        #expect(menu.items.count == 4)
        #expect(menu.items.contains(where: { $0.label == "Root only" }))
    }

    private func insertRestrictedMenuItem(
        connection: any DatabaseConnection
    ) async throws {
        try await connection.run(
            query: """
                INSERT INTO web_menu_item (
                    id,
                    menu_id,
                    label,
                    url,
                    priority,
                    is_blank,
                    permission,
                    notes,
                    created_at,
                    updated_at
                )
                VALUES (
                    'sample-menu-item-root-only',
                    'sample-main-menu',
                    'Root only',
                    '/admin/',
                    40,
                    FALSE,
                    'system:permissions:list',
                    'Restricted seeded item for tests.',
                    NOW(),
                    NOW()
                )
                ON CONFLICT DO NOTHING;
                """
        ) { _ in }
    }
}
