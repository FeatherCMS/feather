import FeatherHTTP
import FeatherDatabase
import HTTPTypes
import OpenAPIRuntime
import AdminOpenAPI

extension TestRunner {

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

                    try await connection.run(
                        query: """
                            INSERT INTO auth_role_permission (
                                role_id,
                                permission_id,
                                created_at,
                                updated_at
                            )
                            VALUES (
                                'root',
                                \(permission),
                                NOW(),
                                NOW()
                            )
                            ON CONFLICT (role_id, permission_id) DO NOTHING;
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
        try await run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/auth/login",
                body: Components.Schemas.UserAuthLoginRequestSchema(
                    email: email,
                    password: password,
                    isPersistent: isPersistent
                )
            )
        ) { response in
            let body = try await response.json(
                status: .ok,
                Components.Schemas.UserAuthMeResponseSchema.self
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
