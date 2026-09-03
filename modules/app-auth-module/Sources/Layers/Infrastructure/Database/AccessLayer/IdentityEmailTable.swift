import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

struct IdentityEmailTable {

    struct Row {
        let id: String
        let identityId: String
        let email: String
        let isPrimary: Bool
        let isVerified: Bool
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func list() async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM auth_identity_email
                ORDER BY email ASC;
                """#
        ) { sequence in
            try await sequence.collect().map { try decode($0) }
        }
    }

    func find(
        id: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT * FROM auth_identity_email
                WHERE id=\#(id)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try decode(row)
        }
    }

    func findBy(
        identityId: String,
        email: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT * FROM auth_identity_email
                WHERE identity_id=\#(identityId) AND email=\#(email)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try decode(row)
        }
    }

    func findBy(email: String) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT * FROM auth_identity_email
                WHERE email=\#(email)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try decode(row)
        }
    }

    func save(
        id: String,
        identityId: String,
        email: String
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO auth_identity_email (
                    id, identity_id, email, is_primary, is_verified,
                    created_at, updated_at
                ) VALUES (
                    \#(id), \#(identityId), \#(email), TRUE, FALSE,
                    NOW(), NOW()
                )
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try decode(row)
        }
    }

    func update(
        id: String,
        identityId: String,
        email: String,
        isPrimary: Bool,
        isVerified: Bool
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                UPDATE auth_identity_email
                SET identity_id=\#(identityId), email=\#(email),
                    is_primary=\#(isPrimary), is_verified=\#(isVerified), updated_at=NOW()
                WHERE id=\#(id)
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try decode(row)
        }
    }

    func delete(ids: [String]) async throws -> [String] {
        guard !ids.isEmpty else { return [] }
        let values =
            ids.map { "'\($0.replacingOccurrences(of: "'", with: "''"))'" }
            .joined(separator: ", ")
        return try await connection.run(
            query: #"""
                DELETE FROM auth_identity_email WHERE id IN (\#(unescaped: values)) RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect()
                .map { try $0.decode(column: "id", as: String.self) }
        }
    }

    private func decode(_ row: DatabaseRow) throws -> Row {
        .init(
            id: try row.decode(column: "id", as: String.self),
            identityId: try row.decode(column: "identity_id", as: String.self),
            email: try row.decode(column: "email", as: String.self),
            isPrimary: try row.decode(column: "is_primary", as: Bool.self),
            isVerified: try row.decode(column: "is_verified", as: Bool.self),
            createdAt: try row.decode(column: "created_at", as: Date.self),
            updatedAt: try row.decode(column: "updated_at", as: Date.self)
        )
    }
}
