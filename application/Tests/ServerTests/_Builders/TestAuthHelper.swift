import FeatherHTTP
import FeatherDatabase
import HTTPTypes
import OpenAPIRuntime
import AuthAdminAPI
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
        password: String = "very-secure-password",
        isPersistent: Bool = true
    ) async throws -> String {
        let result = try await run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/auth/credentials",
                headerFields: [
                    .authorization: bearerAuthorizationHeader(token: token)
                ],
                body: AuthAdminAPI.Components.Schemas.AuthCredentialCreateSchema(
                    userId: userId,
                    email: email,
                    password: password,
                    isPersistent: isPersistent
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
                                name,
                                notes,
                                created_at,
                                updated_at
                            )
                            VALUES (
                                \(permission),
                                \(permission),
                                '',
                                NOW(),
                                NOW()
                            )
                            ON CONFLICT (id) DO NOTHING;
                            """
                    ) { _ in }
                }
            }
        }
    }

    func authenticateTestAccount(
        email: String = "mail.tib@gmail.com",
        password: String = "root",
        isPersistent: Bool = true
    ) async throws -> String {
        let body = Components.Schemas.AuthLoginRequestSchema(
            email: email,
            password: password,
            isPersistent: isPersistent
        )
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/auth/login",
            body: body
        )

        return try await run(
            request: request
        ) { response -> String in
            let body = try await response.json(
                status: .ok,
                Components.Schemas.AuthResponseSchema.self
            )
            guard
                let token = response.response.headerFields[.setCookie],
                !token.isEmpty
            else {
                return body.token
            }
            return token
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
