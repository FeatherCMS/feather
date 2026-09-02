import FeatherDatabase
import FeatherInfrastructure
import NewsletterDomain

import struct Foundation.Date

extension IssueTable.Row {

    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.newsletterId = try row.decode(
            column: "newsletter_id",
            as: String.self
        )
        self.subject = try row.decode(column: "subject", as: String.self)
        self.previewText = try row.decode(
            column: "preview_text",
            as: String.self
        )
        self.content = try row.decode(column: "content", as: String.self)
        self.status = try row.decode(column: "status", as: String.self)
        self.scheduledDate = try row.decode(
            column: "scheduled_date",
            as: Date?.self
        )
        self.sentDate = try row.decode(column: "sent_date", as: Date?.self)
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct IssueTable {

    struct Row {

        struct Create {
            let id: String
            let newsletterId: String
            let subject: String
            let previewText: String
            let content: String
            let status: String
            let scheduledDate: Date?
        }

        let id: String
        let newsletterId: String
        let subject: String
        let previewText: String
        let content: String
        let status: String
        let scheduledDate: Date?
        let sentDate: Date?
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func list(
        newsletterId: String
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT * FROM newsletter_issue
                WHERE newsletter_id = \#(newsletterId)
                ORDER BY created_at DESC;
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
                INSERT INTO newsletter_issue (
                    id, newsletter_id, subject, preview_text, content, status,
                    scheduled_date, created_at, updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.newsletterId),
                    \#(row.subject),
                    \#(row.previewText),
                    \#(row.content),
                    \#(row.status),
                    CASE WHEN \#(row.scheduledDate == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.scheduledDate?.timeIntervalSince1970 ?? 0)) END,
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
                SELECT * FROM newsletter_issue
                WHERE id = \#(id)
                LIMIT 1;
                """#
        ) { sequence in
            try await sequence.collect().first.map { try Row(from: $0) }
        }
    }

    func update(
        id: String,
        row: Row
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                UPDATE newsletter_issue
                SET subject = \#(row.subject),
                    preview_text = \#(row.previewText),
                    content = \#(row.content),
                    status = \#(row.status),
                    scheduled_date = CASE WHEN \#(row.scheduledDate == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.scheduledDate?.timeIntervalSince1970 ?? 0)) END,
                    sent_date = CASE WHEN \#(row.sentDate == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.sentDate?.timeIntervalSince1970 ?? 0)) END,
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
                DELETE FROM newsletter_issue
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
