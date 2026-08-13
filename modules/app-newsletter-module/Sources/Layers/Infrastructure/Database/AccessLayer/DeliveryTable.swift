import FeatherDatabase
import FeatherInfrastructure
import NewsletterDomain

import struct Foundation.Date

extension DeliveryTable.Row {

    init(from row: DatabaseRow) throws {
        self.issueId = try row.decode(column: "issue_id", as: String.self)
        self.newsletterId = try row.decode(
            column: "newsletter_id",
            as: String.self
        )
        self.subscriberEmail = try row.decode(
            column: "subscriber_email",
            as: String.self
        )
        self.status = try row.decode(column: "status", as: String.self)
        self.sentDate = try row.decode(column: "sent_date", as: Date?.self)
        self.failureReason = try row.decode(
            column: "failure_reason",
            as: String?.self
        )
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct DeliveryTable {

    struct Row {

        struct Create {
            let issueId: String
            let newsletterId: String
            let subscriberEmail: String
            let status: String
            let sentDate: Date?
            let failureReason: String?
        }

        let issueId: String
        let newsletterId: String
        let subscriberEmail: String
        let status: String
        let sentDate: Date?
        let failureReason: String?
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func list(
        issueId: String
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT * FROM newsletter_delivery
                WHERE issue_id = \#(issueId)
                ORDER BY created_at ASC, subscriber_email ASC;
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
                INSERT INTO newsletter_delivery (
                    issue_id, newsletter_id, subscriber_email, status,
                    sent_date, failure_reason, created_at, updated_at
                )
                VALUES (
                    \#(row.issueId),
                    \#(row.newsletterId),
                    \#(row.subscriberEmail),
                    \#(row.status),
                    CASE WHEN \#(row.sentDate == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.sentDate?.timeIntervalSince1970 ?? 0)) END,
                    \#(row.failureReason),
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
        issueId: String,
        subscriberEmail: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT * FROM newsletter_delivery
                WHERE issue_id = \#(issueId)
                  AND subscriber_email = \#(subscriberEmail)
                LIMIT 1;
                """#
        ) { sequence in
            try await sequence.collect().first.map { try Row(from: $0) }
        }
    }

    func update(
        issueId: String,
        subscriberEmail: String,
        row: Row
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                UPDATE newsletter_delivery
                SET status = \#(row.status),
                    sent_date = CASE WHEN \#(row.sentDate == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.sentDate?.timeIntervalSince1970 ?? 0)) END,
                    failure_reason = \#(row.failureReason),
                    updated_at = NOW()
                WHERE issue_id = \#(issueId)
                  AND subscriber_email = \#(subscriberEmail)
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
