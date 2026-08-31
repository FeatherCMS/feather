import AccountAdminAPI
import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

@testable import Server

@Suite
struct AdminAPIAccountUserProfileTests {

    @Test
    func adminCanReadAndUpdateAnotherUsersProfile() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "user:accounts:create",
            "account:profile:manage",
        ])
        let token = try await runner.authenticateTestAccount()
        let userID = try await runner.createTestIdentity(token: token)
        let headers = HTTPFields([
            HTTPField(
                name: .authorization,
                value: runner.bearerAuthorizationHeader(token: token)
            )
        ])

        let updated = try await runner.run(
            request: JSONRequest(
                method: .put,
                path: "/api/v1/admin/account/users/\(userID)/profile",
                headerFields: headers,
                body: AccountAdminAPI.Components.Schemas.AccountProfileUpdateSchema(
                    firstName: "Ada",
                    lastName: "Lovelace",
                    imageURL: nil
                )
            )
        ) { response in
            try await response.json(
                status: .ok,
                AccountAdminAPI.Components.Schemas.AccountProfileResponseSchema.self
            )
        }

        #expect(updated.firstName == "Ada")
        #expect(updated.lastName == "Lovelace")
    }
}
