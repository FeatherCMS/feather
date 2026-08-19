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
        try await runner.grantRootPermissions([
            "auth:credential:create",
            "auth:credential:list",
        ])
        let authentication = try await runner.authenticateTestAccount()
        let identityId = try await runner.identityID(
            token: authentication
        )
        let email = "credential-\(UUID().uuidString.lowercased())@example.com"

        let created = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/credentials",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: authentication
                    )
                ],
                body: Components.Schemas.AuthCredentialCreateSchema(
                    userId: identityId,
                    email: email,
                    password: "very-secure-password",
                    isPersistent: true
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.AuthCredentialDetailSchema.self
            )
        }

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/credentials/search",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: authentication
                    )
                ],
                body: Components.Schemas
                    .AuthCredentialListItemSearchQuerySchema(
                        page: .init(size: 10, number: 1),
                        sort: [],
                        filters: .init(
                            search: created.id,
                            userId: identityId
                        )
                    )
            )
        ) { response in
            let object = try await response.json(
                status: .ok,
                Components.Schemas.AuthCredentialListItemSearchSchema.self
            )
            #expect(object.data.total == 1)
            #expect(object.data.items.first?.id == created.id)
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
        try await runner.grantRootPermissions([
            "auth:credential:create",
            "auth:credential:list",
        ])
        let authentication = try await runner.authenticateTestAccount()
        let identityId = try await runner.identityID(
            token: authentication
        )
        let email = "credential-\(UUID().uuidString.lowercased())@example.com"

        let created = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/credentials",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: authentication
                    )
                ],
                body: Components.Schemas.AuthCredentialCreateSchema(
                    userId: identityId,
                    email: email,
                    password: "very-secure-password",
                    isPersistent: true
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.AuthCredentialDetailSchema.self
            )
        }

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/credentials/search",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: authentication
                    )
                ],
                body: Components.Schemas
                    .AuthCredentialListItemSearchQuerySchema(
                        page: .init(size: 10, number: 1),
                        sort: [],
                        filters: .init(search: created.id)
                    )
            )
        ) { response in
            let object = try await response.json(
                status: .ok,
                Components.Schemas.AuthCredentialListItemSearchSchema.self
            )
            #expect(object.data.total == 1)
            #expect(object.data.items.first?.id == created.id)
            #expect(object.data.items.first?.userId == identityId)
            #expect(object.data.items.first?.email == email)
        }
    }

    @Test
    func searchCredentialsReturnsNoResultsForNonMatchingAccountID() async throws
    {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "auth:credential:create",
            "auth:credential:list",
        ])
        let authentication = try await runner.authenticateTestAccount()
        let identityId = try await runner.identityID(
            token: authentication
        )
        let email = "credential-\(UUID().uuidString.lowercased())@example.com"

        let created = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/credentials",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: authentication
                    )
                ],
                body: Components.Schemas.AuthCredentialCreateSchema(
                    userId: identityId,
                    email: email,
                    password: "very-secure-password",
                    isPersistent: true
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                Components.Schemas.AuthCredentialDetailSchema.self
            )
        }

        let nonMatchingAccountID = "account-\(UUID().uuidString.lowercased())"

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/credentials/search",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: authentication
                    )
                ],
                body: Components.Schemas
                    .AuthCredentialListItemSearchQuerySchema(
                        page: .init(size: 10, number: 1),
                        sort: [],
                        filters: .init(
                            search: created.id,
                            userId: nonMatchingAccountID
                        )
                    )
            )
        ) { response in
            let object = try await response.json(
                status: .ok,
                Components.Schemas.AuthCredentialListItemSearchSchema.self
            )
            #expect(object.data.total == 0)
            #expect(object.data.items.isEmpty)
        }
    }
}
