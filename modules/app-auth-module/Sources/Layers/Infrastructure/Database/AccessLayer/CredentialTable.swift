import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension CredentialTable.Row {

    fileprivate init(
        from row: DatabaseRow,
        includesIdentityName: Bool = false
    ) throws {
        self.init(
            id: try row.decode(column: "id", as: String.self),
            authEmailId: try row.decode(
                column: "auth_email_id",
                as: String.self
            ),
            userId: try row.decode(
                column: "user_id",
                as: String.self
            ),
            email: try row.decode(column: "email", as: String.self),
            identityName: includesIdentityName
                ? try row.decode(column: "identity_name", as: String?.self)
                : nil,
            passwordHash: try row.decode(
                column: "password_hash",
                as: String.self
            ),
            createdAt: try row.decode(
                column: "created_at",
                as: Date.self
            ),
            updatedAt: try row.decode(
                column: "updated_at",
                as: Date.self
            )
        )
    }
}

public struct CredentialTable {

    public struct Row: Sendable {

        public let id: String
        public let authEmailId: String
        public let userId: String
        public let identityName: String?
        public let email: String
        public let passwordHash: String
        public let createdAt: Date
        public let updatedAt: Date

        public init(
            id: String,
            authEmailId: String,
            userId: String,
            email: String,
            identityName: String? = nil,
            passwordHash: String,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.authEmailId = authEmailId
            self.userId = userId
            self.email = email
            self.identityName = identityName
            self.passwordHash = passwordHash
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }

    public let connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func list(
        userId: String? = nil,
        search: String?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT auth_email_credential.*, auth_email.identity_id AS user_id,
                    auth_email.email AS email,
                    user_identity.name AS identity_name
                FROM auth_email_credential
                INNER JOIN auth_email
                    ON auth_email.id = auth_email_credential.auth_email_id
                INNER JOIN user_identity
                    ON user_identity.id = auth_email.identity_id
                WHERE (
                    \#(userId == nil)
                    OR auth_email.identity_id=\#(userId ?? "")
                )
                AND (
                    \#(search == nil)
                    OR LOWER(auth_email_credential.id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(auth_email.identity_id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(user_identity.name, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(auth_email.email) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                )
                ORDER BY \#(unescaped: orderBy)
                LIMIT \#(limit)
                OFFSET \#(offset);
                """#
        ) { sequence in
            try await sequence.collect()
                .map {
                    try Row(from: $0, includesIdentityName: true)
                }
        }
    }

    public func count(
        userId: String? = nil,
        search: String?
    ) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM auth_email_credential
                INNER JOIN auth_email
                    ON auth_email.id = auth_email_credential.auth_email_id
                INNER JOIN user_identity
                    ON user_identity.id = auth_email.identity_id
                WHERE (
                    \#(userId == nil)
                    OR auth_email.identity_id=\#(userId ?? "")
                )
                AND (
                    \#(search == nil)
                    OR LOWER(auth_email_credential.id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(auth_email.identity_id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(user_identity.name, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(auth_email.email) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                );
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return 0
            }
            return try row.decode(column: "count", as: Int.self)
        }
    }

    public func find(
        id: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT auth_email_credential.*, auth_email.identity_id AS user_id,
                    auth_email.email AS email
                FROM auth_email_credential
                INNER JOIN auth_email
                    ON auth_email.id = auth_email_credential.auth_email_id
                WHERE auth_email_credential.id=\#(id)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    public func findBy(
        userId: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT auth_email_credential.*, auth_email.identity_id AS user_id,
                    auth_email.email AS email
                FROM auth_email_credential
                INNER JOIN auth_email
                    ON auth_email.id = auth_email_credential.auth_email_id
                WHERE auth_email.identity_id=\#(userId)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    public func findBy(
        email: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT auth_email_credential.*, auth_email.identity_id AS user_id,
                    auth_email.email AS email
                FROM auth_email_credential
                INNER JOIN auth_email
                    ON auth_email.id = auth_email_credential.auth_email_id
                WHERE auth_email.email=\#(email)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    public func save(
        row: Row
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                WITH inserted AS (
                    INSERT INTO auth_email_credential (
                    id,
                    auth_email_id,
                    password_hash,
                    created_at,
                    updated_at
                )
                    VALUES (
                        \#(row.id),
                        \#(row.authEmailId),
                        \#(row.passwordHash),
                        NOW(),
                        NOW()
                    )
                    RETURNING *
                )
                SELECT inserted.*, auth_email.identity_id AS user_id,
                    auth_email.email AS email
                FROM inserted
                INNER JOIN auth_email
                    ON auth_email.id = inserted.auth_email_id;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    public func update(
        id: String,
        row: Row
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                WITH updated AS (
                    UPDATE auth_email_credential
                    SET
                        id=\#(row.id),
                        auth_email_id=\#(row.authEmailId),
                        password_hash=\#(row.passwordHash),
                        updated_at=NOW()
                    WHERE id=\#(id)
                    RETURNING *
                )
                SELECT updated.*, auth_email.identity_id AS user_id,
                    auth_email.email AS email
                FROM updated
                INNER JOIN auth_email
                    ON auth_email.id = updated.auth_email_id;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        guard !ids.isEmpty else { return [] }
        let values =
            ids.map {
                "'\($0.replacingOccurrences(of: "'", with: "''"))'"
            }
            .joined(separator: ", ")
        return try await connection.run(
            query: #"""
                DELETE FROM auth_email_credential
                WHERE id IN (\#(unescaped: values))
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect()
                .map {
                    try $0.decode(column: "id", as: String.self)
                }
        }
    }
}
