import ContactDomain
import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension SubmissionTable.Row {

    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.formId = try row.decode(column: "form_id", as: String.self)
        self.valuesJSON = try row.decode(column: "values", as: String.self)
        self.itemsSnapshotJSON = try row.decode(
            column: "items_snapshot",
            as: String.self
        )
        self.metadataJSON = try row.decode(column: "metadata", as: String?.self)
        self.status = try row.decode(column: "status", as: String.self)
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct SubmissionTable {

    struct Row {
        struct Create {
            let id: String
            let formId: String
            let valuesJSON: String
            let itemsSnapshotJSON: String
            let metadataJSON: String?
            let status: String
        }

        let id: String
        let formId: String
        let valuesJSON: String
        let itemsSnapshotJSON: String
        let metadataJSON: String?
        let status: String
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func list(
        formId: String
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT * FROM contact_form_submission
                WHERE form_id = \#(formId)
                ORDER BY created_at DESC, id DESC;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func create(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO contact_form_submission (
                    id, form_id, "values", items_snapshot, metadata, status,
                    created_at, updated_at
                )
                VALUES (
                    \#(row.id), \#(row.formId), \#(row.valuesJSON)::jsonb,
                    \#(row.itemsSnapshotJSON)::jsonb,
                    CASE WHEN \#(row.metadataJSON == nil) THEN NULL ELSE \#(row.metadataJSON)::jsonb END,
                    \#(row.status), NOW(), NOW()
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
                SELECT * FROM contact_form_submission
                WHERE id = \#(id)
                LIMIT 1;
                """#
        ) { sequence in
            try await sequence.collect().first.map { try Row(from: $0) }
        }
    }

    func update(
        id: String,
        status: String
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                UPDATE contact_form_submission
                SET status = \#(status), updated_at = NOW()
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
                DELETE FROM contact_form_submission
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
