import NewsletterDomain
import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension NewsletterCampaignSubscriberTable.Row {

    init(from row: DatabaseRow) throws {
        self.newsletterId = try row.decode(
            column: "newsletter_id",
            as: String.self
        )
        self.email = try row.decode(column: "email", as: String.self)
        self.status = try row.decode(column: "status", as: String.self)
        self.subscriptionDate = try row.decode(
            column: "subscription_date",
            as: Date.self
        )
        self.unsubscriptionDate = try row.decode(
            column: "unsubscription_date",
            as: Date?.self
        )
        self.firstName = try row.decode(column: "first_name", as: String.self)
        self.lastName = try row.decode(column: "last_name", as: String.self)
        self.confirmedAt = try row.decode(column: "confirmed_at", as: Date?.self)
        self.unsubscribeToken = try row.decode(
            column: "unsubscribe_token",
            as: String?.self
        )
        self.source = try row.decode(column: "source", as: String?.self)
        self.lastSentAt = try row.decode(column: "last_sent_at", as: Date?.self)
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct NewsletterCampaignSubscriberTable {

    struct Row {

        struct Create {
            let newsletterId: String
            let email: String
            let status: String
            let subscriptionDate: Date
            let unsubscriptionDate: Date?
            let firstName: String
            let lastName: String
            let confirmedAt: Date?
            let unsubscribeToken: String?
            let source: String?
            let lastSentAt: Date?
        }

        let newsletterId: String
        let email: String
        let status: String
        let subscriptionDate: Date
        let unsubscriptionDate: Date?
        let firstName: String
        let lastName: String
        let confirmedAt: Date?
        let unsubscribeToken: String?
        let source: String?
        let lastSentAt: Date?
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func list(
        newsletterId: String
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM newsletter_subscriber
                WHERE newsletter_id = \#(newsletterId)
                ORDER BY email ASC;
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
                INSERT INTO newsletter_subscriber (
                    newsletter_id,
                    email,
                    status,
                    subscription_date,
                    unsubscription_date,
                    first_name,
                    last_name,
                    confirmed_at,
                    unsubscribe_token,
                    source,
                    last_sent_at,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.newsletterId),
                    \#(row.email),
                    \#(row.status),
                    TO_TIMESTAMP(\#(row.subscriptionDate.timeIntervalSince1970)),
                    CASE
                        WHEN \#(row.unsubscriptionDate == nil) THEN NULL
                        ELSE TO_TIMESTAMP(\#(row.unsubscriptionDate?.timeIntervalSince1970 ?? 0))
                    END,
                    \#(row.firstName),
                    \#(row.lastName),
                    CASE WHEN \#(row.confirmedAt == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.confirmedAt?.timeIntervalSince1970 ?? 0)) END,
                    \#(row.unsubscribeToken),
                    \#(row.source),
                    CASE WHEN \#(row.lastSentAt == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.lastSentAt?.timeIntervalSince1970 ?? 0)) END,
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
        newsletterId: String,
        email: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM newsletter_subscriber
                WHERE newsletter_id = \#(newsletterId)
                  AND email = \#(email)
                LIMIT 1;
                """#
        ) { sequence in
            try await sequence.collect().first.map { try Row(from: $0) }
        }
    }

    func update(
        newsletterId: String,
        email: String,
        row: Row
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                UPDATE newsletter_subscriber
                SET
                    status = \#(row.status),
                    subscription_date = TO_TIMESTAMP(\#(row.subscriptionDate.timeIntervalSince1970)),
                    unsubscription_date = CASE
                        WHEN \#(row.unsubscriptionDate == nil) THEN NULL
                        ELSE TO_TIMESTAMP(\#(row.unsubscriptionDate?.timeIntervalSince1970 ?? 0))
                    END,
                    first_name = \#(row.firstName),
                    last_name = \#(row.lastName),
                    confirmed_at = CASE WHEN \#(row.confirmedAt == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.confirmedAt?.timeIntervalSince1970 ?? 0)) END,
                    unsubscribe_token = \#(row.unsubscribeToken),
                    source = \#(row.source),
                    last_sent_at = CASE WHEN \#(row.lastSentAt == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.lastSentAt?.timeIntervalSince1970 ?? 0)) END,
                    updated_at = NOW()
                WHERE newsletter_id = \#(newsletterId)
                  AND email = \#(email)
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
        newsletterId: String,
        email: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                DELETE FROM newsletter_subscriber
                WHERE newsletter_id = \#(newsletterId)
                  AND email = \#(email)
                RETURNING newsletter_id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
