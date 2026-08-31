import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AccountAppAPI

@testable import Server

@Suite
struct AppAPIAccountProfileTests {

    @Test
    func authenticatedUserCanReadAndUpdateOwnAccountProfile() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()

        let token = try await runner.authenticateTestAccount()
        let headers = HTTPFields([
            HTTPField(
                name: .authorization,
                value: runner.bearerAuthorizationHeader(token: token)
            )
        ])

        let initial = try await runner.run(
            request: JSONRequest(
                method: .get,
                path: "/api/v1/account/profile",
                headerFields: headers,
                body: ""
            )
        ) { response in
            try await response.json(
                status: .ok,
                Components.Schemas.AccountProfileResponseSchema.self
            )
        }

        #expect(initial.firstName == nil)
        #expect(initial.lastName == nil)
        #expect(initial.imageURL == nil)

        let updated = try await runner.run(
            request: JSONRequest(
                method: .put,
                path: "/api/v1/account/profile",
                headerFields: headers,
                body: Components.Schemas.AccountProfileUpdateSchema(
                    firstName: "Ada",
                    lastName: "Lovelace",
                    imageURL: "https://example.com/ada.png"
                )
            )
        ) { response in
            try await response.json(
                status: .ok,
                Components.Schemas.AccountProfileResponseSchema.self
            )
        }

        #expect(updated.firstName == "Ada")
        #expect(updated.lastName == "Lovelace")
        #expect(updated.imageURL == "https://example.com/ada.png")

        let persisted = try await runner.run(
            request: JSONRequest(
                method: .get,
                path: "/api/v1/account/profile",
                headerFields: headers,
                body: ""
            )
        ) { response in
            try await response.json(
                status: .ok,
                Components.Schemas.AccountProfileResponseSchema.self
            )
        }

        #expect(persisted.firstName == "Ada")
        #expect(persisted.lastName == "Lovelace")
        #expect(persisted.imageURL == "https://example.com/ada.png")
    }
}
