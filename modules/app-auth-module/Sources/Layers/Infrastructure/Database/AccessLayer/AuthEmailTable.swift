import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

struct AuthEmailTable {

    struct Row {
        let id: String
        let identityId: String
        let email: String
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func list() async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM auth_email
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
                SELECT * FROM auth_email
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
                SELECT * FROM auth_email
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
                SELECT * FROM auth_email
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
                INSERT INTO auth_email (
                    id, identity_id, email, created_at, updated_at
                ) VALUES (
                    \#(id), \#(identityId), \#(email),
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
        email: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                UPDATE auth_email
                SET identity_id=\#(identityId), email=\#(email), updated_at=NOW()
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
                DELETE FROM auth_email WHERE id IN (\#(unescaped: values)) RETURNING id;
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
            createdAt: try row.decode(column: "created_at", as: Date.self),
            updatedAt: try row.decode(column: "updated_at", as: Date.self)
        )
    }
}
