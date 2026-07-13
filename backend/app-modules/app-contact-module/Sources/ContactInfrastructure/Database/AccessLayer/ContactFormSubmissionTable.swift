import ContactDomain
import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension ContactFormSubmissionTable.Row {

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
        self.submittedAt = try row.decode(column: "submitted_at", as: Date.self)
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct ContactFormSubmissionTable {

    struct Row {
        struct Create {
            let id: String
            let formId: String
            let valuesJSON: String
            let itemsSnapshotJSON: String
            let metadataJSON: String?
            let status: String
            let submittedAt: Date
        }

        let id: String
        let formId: String
        let valuesJSON: String
        let itemsSnapshotJSON: String
        let metadataJSON: String?
        let status: String
        let submittedAt: Date
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func list(
        formId: String
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT * FROM contact_form_submissions
                WHERE form_id = \#(formId)
                ORDER BY submitted_at DESC, id DESC;
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
                INSERT INTO contact_form_submissions (
                    id, form_id, "values", items_snapshot, metadata, status,
                    submitted_at, created_at, updated_at
                )
                VALUES (
                    \#(row.id), \#(row.formId), \#(row.valuesJSON)::jsonb,
                    \#(row.itemsSnapshotJSON)::jsonb,
                    CASE WHEN \#(row.metadataJSON == nil) THEN NULL ELSE \#(row.metadataJSON)::jsonb END,
                    \#(row.status), TO_TIMESTAMP(\#(row.submittedAt.timeIntervalSince1970)),
                    NOW(), NOW()
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
                SELECT * FROM contact_form_submissions
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
                UPDATE contact_form_submissions
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
}
