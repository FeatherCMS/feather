import FeatherHTTP
import FeatherDatabase
import HTTPTypes
import OpenAPIRuntime
import AuthAdminAPI
import AuthAppAPI
import UserAdminAPI

extension TestRunner {

    func createTestIdentity(
        token: String,
        status: UserAdminAPI.Components.Schemas.UserIdentityStatusField? = nil
    ) async throws -> String {
        let result = try await run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/identities",
                headerFields: [
                    .authorization: bearerAuthorizationHeader(token: token)
                ],
                body: UserAdminAPI.Components.Schemas.UserIdentityCreateSchema(
                    name: "Test User",
                    status: status
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                UserAdminAPI.Components.Schemas.UserIdentityDetailSchema.self
            )
        }

        return result.id
    }

    func createTestCredential(
        token: String,
        userId: String,
        email: String,
        password: String = "very-secure-password"
    ) async throws -> String {
        try await run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/emails",
                headerFields: [
                    .authorization: bearerAuthorizationHeader(token: token)
                ],
                body: AuthAdminAPI.Components.Schemas.AuthEmailSchemasCreate(
                    identityId: userId,
                    email: email
                )
            )
        ) { response in
            try await response.json(
                status: .created,
                AuthAdminAPI.Components.Schemas.AuthEmailSchemasDetail.self
            )
        }

        let result = try await run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/credentials",
                headerFields: [
                    .authorization: bearerAuthorizationHeader(token: token)
                ],
                body: AuthAdminAPI.Components.Schemas
                    .AuthCredentialCreateSchema(
                        userId: userId,
                        email: email,
                        password: password
                    )
            )
        ) { response in
            try await response.json(
                status: .created,
                AuthAdminAPI.Components.Schemas.AuthCredentialDetailSchema.self
            )
        }

        return result.id
    }

    func identityID(
        token: String
    ) async throws -> String {
        guard !token.isEmpty else {
            throw TestAuthError.invalidAuthenticationValue
        }

        return try await system.databaseClient.execute { database in
            try await database.withConnection { connection in
                try await connection.run(
                    query: #"""
                        SELECT identity_id
                        FROM auth_session
                        WHERE token=\#(token)
                        LIMIT 1;
                        """#
                ) { sequence in
                    guard let row = try await sequence.collect().first else {
                        throw TestAuthError.sessionNotFound
                    }
                    return try row.decode(
                        column: "identity_id",
                        as: String.self
                    )
                }
            }
        }
    }

    func grantRootPermissions(
        _ permissions: [String]
    ) async throws {
        try await system.databaseClient.execute { database in
            try await database.withConnection { connection in
                for permission in permissions {
                    try await connection.run(
                        query: """
                            INSERT INTO system_permission (
                                id,
                                key,
                                name,
                                notes,
                                created_at,
                                updated_at
                            )
                            VALUES (
                                \(permission),
                                \(permission),
                                \(permission),
                                '',
                                NOW(),
                                NOW()
                            )
                            ON CONFLICT DO NOTHING;
                            """
                    ) { _ in }
                }
            }
        }
    }

    func authenticateTestAccount(
        email: String = "mail.viaszkadi@gmail.com",
        password: String = "root",
        isPersistent: Bool = true
    ) async throws -> String {
        let body = AuthAppAPI.Components.Schemas.AuthLoginRequestSchema(
            email: email,
            password: password,
            isPersistent: isPersistent
        )
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/auth/login",
            body: body
        )

        return try await run(
            request: request
        ) { response -> String in
            let body = try await response.json(
                status: .ok,
                AuthAppAPI.Components.Schemas
                    .AuthSchemasSignInResponse.self
            )
            return body.token
        }
    }

    func bearerAuthorizationHeader(
        token: String
    ) -> String {
        "Bearer \(token)"
    }
}

private enum TestAuthError: Error {
    case invalidAuthenticationValue
    case sessionNotFound
}
