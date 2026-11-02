import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AuthAdminAPI

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@testable import Server

@Suite
struct AdminAPIUserCredentialSearchTests {

    @Test
    func searchCredentialsWithAccountIDFilterIsOkForAuthorizedUser()
        async throws
    {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        let token = try await runner.authenticateTestAccount()
        let identityId = try await runner.identityID(token: token)
        let email = "credential-\(UUID().uuidString.lowercased())@example.com"
        let credentialID = try await runner.createTestCredential(
            token: token,
            userId: identityId,
            email: email
        )

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/credentials/query",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas
                    .AuthCredentialQueryItemSearchRequestQuerySchema(
                        page: .init(size: 10, number: 1),
                        sort: [],
                        filters: .init(
                            search: credentialID,
                            userId: identityId
                        )
                    )
            )
        ) { response in
            let object = try await response.json(
                status: .ok,
                Components.Schemas.AuthCredentialQueryItemSearchSchema.self
            )
            #expect(object.data.total == 1)
            #expect(object.data.items.first?.id == credentialID)
            #expect(object.data.items.first?.userId == identityId)
            #expect(object.data.items.first?.email == email)
        }
    }

    @Test
    func searchCredentialsWithoutAccountIDFilterIsOkForAuthorizedUser()
        async throws
    {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        let token = try await runner.authenticateTestAccount()
        let identityId = try await runner.identityID(token: token)
        let email = "credential-\(UUID().uuidString.lowercased())@example.com"
        let credentialID = try await runner.createTestCredential(
            token: token,
            userId: identityId,
            email: email
        )

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/credentials/query",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas
                    .AuthCredentialQueryItemSearchRequestQuerySchema(
                        page: .init(size: 10, number: 1),
                        sort: [],
                        filters: .init(search: credentialID)
                    )
            )
        ) { response in
            let object = try await response.json(
                status: .ok,
                Components.Schemas.AuthCredentialQueryItemSearchSchema.self
            )
            #expect(object.data.total == 1)
            #expect(object.data.items.first?.id == credentialID)
            #expect(object.data.items.first?.userId == identityId)
            #expect(object.data.items.first?.email == email)
        }
    }

    @Test
    func searchCredentialsReturnsNoResultsForNonMatchingAccountID() async throws
    {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        let token = try await runner.authenticateTestAccount()
        let identityId = try await runner.identityID(token: token)
        let email = "credential-\(UUID().uuidString.lowercased())@example.com"
        let credentialID = try await runner.createTestCredential(
            token: token,
            userId: identityId,
            email: email
        )
        let nonMatchingAccountID = "account-\(UUID().uuidString.lowercased())"

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/credentials/query",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas
                    .AuthCredentialQueryItemSearchRequestQuerySchema(
                        page: .init(size: 10, number: 1),
                        sort: [],
                        filters: .init(
                            search: credentialID,
                            userId: nonMatchingAccountID
                        )
                    )
            )
        ) { response in
            let object = try await response.json(
                status: .ok,
                Components.Schemas.AuthCredentialQueryItemSearchSchema.self
            )
            #expect(object.data.total == 0)
            #expect(object.data.items.isEmpty)
        }
    }
}
