import AccountAdminAPI
import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

@testable import Server

@Suite
struct AdminAPIAccountSettingsTests {

    @Test
    func authenticatedUserCanReadAndUpdateOwnSettings() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        let token = try await runner.authenticateTestAccount()
        let headers = HTTPFields([
            HTTPField(
                name: .authorization,
                value: runner.bearerAuthorizationHeader(token: token)
            )
        ])

        let settings = try await runner.run(
            request: JSONRequest(
                method: .get,
                path: "/api/v1/admin/account/settings",
                headerFields: headers,
                body: [String: String]()
            )
        ) { response in
            try await response.json(
                status: .ok,
                AccountAdminAPI.Components.Schemas.AccountSettingsDetailSchema
                    .self
            )
        }

        let updated = try await runner.run(
            request: JSONRequest(
                method: .put,
                path: "/api/v1/admin/account/settings",
                headerFields: headers,
                body: AccountAdminAPI.Components.Schemas
                    .AccountSettingsUpdateSchema(
                        language: settings.language,
                        timezone: settings.timezone,
                        pageSize: settings.pageSize
                    )
            )
        ) { response in
            try await response.json(
                status: .ok,
                AccountAdminAPI.Components.Schemas.AccountSettingsDetailSchema
                    .self
            )
        }

        #expect(updated.language == settings.language)
        #expect(updated.timezone == settings.timezone)
        #expect(updated.pageSize == settings.pageSize)
    }
}
