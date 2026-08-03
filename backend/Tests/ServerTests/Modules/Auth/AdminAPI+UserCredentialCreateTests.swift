import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AdminOpenAPI

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@testable import Server

@Suite
struct AdminAPIUserCredentialCreateTests {

    @Test
    func createCredentialIsCreatedForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "auth:credential:create"
        ])
        let authentication = try await runner.authenticateTestAccount()
        let accountID = try await runner.accountID(
            token: authentication
        )

        let email = "credential-\(UUID().uuidString.lowercased())@example.com"
        let credential = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/credential",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: authentication
                    )
                ],
                body: Components.Schemas.UserCredentialCreateSchema(
                    accountID: accountID,
                    email: email,
                    password: "very-secure-password"
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.UserCredentialDetailSchema.self
            )
        }

        #expect(!credential.id.isEmpty)
        #expect(credential.accountID == accountID)
        #expect(credential.email == email)
    }
}
