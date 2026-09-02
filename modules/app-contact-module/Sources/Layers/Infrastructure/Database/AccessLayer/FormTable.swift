import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension FormTable.Row {

    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.name = try row.decode(column: "name", as: String.self)
        self.successMessage = try row.decode(
            column: "success_message",
            as: String.self
        )
        self.failureMessage = try row.decode(
            column: "failure_message",
            as: String.self
        )
        self.redirectUrl = try row.decode(
            column: "redirect_url",
            as: String?.self
        )
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct FormTable {

    struct Row {

        struct Create {
            let id: String
            let name: String
            let successMessage: String
            let failureMessage: String
            let redirectUrl: String?
        }

        let id: String
        let name: String
        let successMessage: String
        let failureMessage: String
        let redirectUrl: String?
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func create(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO contact_form (
                    id,
                    name,
                    success_message,
                    failure_message,
                    redirect_url,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.name),
                    \#(row.successMessage),
                    \#(row.failureMessage),
                    \#(row.redirectUrl),
                    NOW(),
                    NOW()
                )
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func find(
        id: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM contact_form
                WHERE id = \#(id)
                LIMIT 1;
                """#
        ) { sequence in
            try await sequence.collect().first.map { try Row(from: $0) }
        }
    }

    func list() async throws -> [Row] {
        try await connection.run(
            query: #"SELECT * FROM contact_form ORDER BY name ASC, id ASC;"#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func update(
        id: String,
        row: Row
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                UPDATE contact_form
                SET
                    name = \#(row.name),
                    success_message = \#(row.successMessage),
                    failure_message = \#(row.failureMessage),
                    redirect_url = \#(row.redirectUrl),
                    updated_at = NOW()
                WHERE id = \#(id)
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func delete(
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
                DELETE FROM contact_form
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
