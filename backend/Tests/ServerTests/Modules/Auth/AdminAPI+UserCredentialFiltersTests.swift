import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AdminOpenAPI

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
                path: "/api/v1/admin/user/credential/filters",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: authentication
                    )
                ]
            )
        ) { response in
            let filters = try await response.json(
                status: .ok,
                Components.Schemas.SearchFilterSchema.self
            )
            #expect(filters == .init())
        }
    }
}
