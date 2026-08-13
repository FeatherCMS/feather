import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AuthAdminAPI

@testable import Server

@Suite
struct AdminAPIUserCredentialFiltersTests {

    @Test
    func credentialFiltersAreOkForAuthenticatedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        let authentication = try await runner.authenticateTestAccount()

        try await runner.run(
            request: Request(
                method: .get,
                path: "/api/v1/admin/auth/credentials/filters",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: authentication
                    )
                ]
            )
        ) { response in
            let filters = try await response.json(
                status: .ok,
                Components.Schemas.AuthCredentialSearchFilterSchema.self
            )
            #expect(filters.search == "")
            #expect(filters.userId == nil)
        }
    }
}
