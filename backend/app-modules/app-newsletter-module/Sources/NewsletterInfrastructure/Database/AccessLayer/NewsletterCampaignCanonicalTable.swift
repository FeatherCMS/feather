import FeatherDatabase
import Infrastructure
import Foundation

struct NewsletterCampaignCanonicalTable {

    let connection: any DatabaseConnection

    func synchronize(
        row: NewsletterCampaignSubscriberTable.Row
    ) async throws {
        try await connection.run(
            query: #"""
                INSERT INTO contact_subscribers (
                    id, email, normalized_email, first_name, last_name, created_at, updated_at
                )
                VALUES (
                    'subscriber-' || md5(lower(trim(\#(row.email)))),
                    \#(row.email), lower(trim(\#(row.email))), \#(row.firstName), \#(row.lastName), NOW(), NOW()
                )
                ON CONFLICT (normalized_email) DO UPDATE SET
                    email = EXCLUDED.email,
                    first_name = EXCLUDED.first_name,
                    last_name = EXCLUDED.last_name,
                    updated_at = NOW();
                """#
        ) { _ in }

        try await connection.run(
            query: #"""
                INSERT INTO newsletter_subscriptions (
                    subscriber_id, newsletter_id, status, subscription_date,
                    unsubscription_date, confirmed_at, unsubscribe_token, source,
                    last_sent_at, created_at, updated_at
                )
                SELECT id, \#(row.newsletterId), \#(row.status),
                       TO_TIMESTAMP(\#(row.subscriptionDate.timeIntervalSince1970)),
                       CASE WHEN \#(row.unsubscriptionDate == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.unsubscriptionDate?.timeIntervalSince1970 ?? 0)) END,
                       CASE WHEN \#(row.confirmedAt == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.confirmedAt?.timeIntervalSince1970 ?? 0)) END,
                       \#(row.unsubscribeToken), \#(row.source),
                       CASE WHEN \#(row.lastSentAt == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.lastSentAt?.timeIntervalSince1970 ?? 0)) END,
                       TO_TIMESTAMP(\#(row.createdAt.timeIntervalSince1970)),
                       TO_TIMESTAMP(\#(row.updatedAt.timeIntervalSince1970))
                FROM contact_subscribers
                WHERE normalized_email = lower(trim(\#(row.email)))
                ON CONFLICT (subscriber_id, newsletter_id) DO UPDATE SET
                    status = EXCLUDED.status,
                    subscription_date = EXCLUDED.subscription_date,
                    unsubscription_date = EXCLUDED.unsubscription_date,
                    confirmed_at = EXCLUDED.confirmed_at,
                    unsubscribe_token = EXCLUDED.unsubscribe_token,
                    source = EXCLUDED.source,
                    last_sent_at = EXCLUDED.last_sent_at,
                    updated_at = EXCLUDED.updated_at;
                """#
        ) { _ in }
    }

    func delete(
        newsletterId: String,
        email: String
    ) async throws {
        try await connection.run(
            query: #"""
                DELETE FROM newsletter_subscriptions
                WHERE newsletter_id = \#(newsletterId)
                  AND subscriber_id = (
                      SELECT id FROM contact_subscribers
                      WHERE normalized_email = lower(trim(\#(email)))
                  );
                """#
        ) { _ in }
    }
}
