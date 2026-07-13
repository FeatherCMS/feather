import FeatherDatabase
import Infrastructure

public struct TableMigration: DatabaseMigration {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func apply(on connection: any DatabaseConnection) async throws {
        let queries: [DatabaseQuery] = [
            #"""
            CREATE TABLE IF NOT EXISTS contact_subscribers (
                id TEXT PRIMARY KEY,
                email TEXT NOT NULL,
                normalized_email TEXT NOT NULL UNIQUE,
                first_name TEXT NOT NULL DEFAULT '',
                last_name TEXT NOT NULL DEFAULT '',
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS newsletter_campaigns (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS newsletter_subscribers (
                newsletter_id TEXT NOT NULL,
                email TEXT NOT NULL,
                status TEXT NOT NULL DEFAULT 'subscribed' CHECK (status IN ('subscribed', 'unsubscribed')),
                subscription_date TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                unsubscription_date TIMESTAMPTZ,
                first_name TEXT NOT NULL DEFAULT '',
                last_name TEXT NOT NULL DEFAULT '',
                confirmed_at TIMESTAMPTZ,
                unsubscribe_token TEXT UNIQUE,
                source TEXT,
                last_sent_at TIMESTAMPTZ,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                PRIMARY KEY (newsletter_id, email),
                FOREIGN KEY(newsletter_id) REFERENCES newsletter_campaigns(id) ON DELETE CASCADE
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS newsletter_issues (
                id TEXT PRIMARY KEY,
                newsletter_id TEXT NOT NULL,
                subject TEXT NOT NULL,
                preview_text TEXT NOT NULL DEFAULT '',
                content TEXT NOT NULL,
                status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'scheduled', 'sending', 'sent', 'failed')),
                scheduled_date TIMESTAMPTZ,
                sent_date TIMESTAMPTZ,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                UNIQUE (id, newsletter_id),
                FOREIGN KEY(newsletter_id) REFERENCES newsletter_campaigns(id) ON DELETE CASCADE
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS newsletter_deliveries (
                issue_id TEXT NOT NULL,
                newsletter_id TEXT NOT NULL,
                subscriber_email TEXT NOT NULL,
                status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'sent', 'failed', 'bounced')),
                sent_date TIMESTAMPTZ,
                failure_reason TEXT,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                PRIMARY KEY (issue_id, subscriber_email),
                FOREIGN KEY(issue_id, newsletter_id) REFERENCES newsletter_issues(id, newsletter_id) ON DELETE CASCADE,
                FOREIGN KEY(newsletter_id, subscriber_email) REFERENCES newsletter_subscribers(newsletter_id, email) ON DELETE CASCADE
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS newsletter_subscriptions (
                subscriber_id TEXT NOT NULL,
                newsletter_id TEXT NOT NULL,
                status TEXT NOT NULL DEFAULT 'subscribed'
                    CHECK (status IN ('subscribed', 'unsubscribed')),
                subscription_date TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                unsubscription_date TIMESTAMPTZ,
                confirmed_at TIMESTAMPTZ,
                unsubscribe_token TEXT UNIQUE,
                source TEXT,
                last_sent_at TIMESTAMPTZ,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                PRIMARY KEY (subscriber_id, newsletter_id),
                FOREIGN KEY(subscriber_id) REFERENCES contact_subscribers(id) ON DELETE CASCADE,
                FOREIGN KEY(newsletter_id) REFERENCES newsletter_campaigns(id) ON DELETE CASCADE
            );
            """#,
            #"CREATE INDEX IF NOT EXISTS contact_subscribers_email_idx ON contact_subscribers (normalized_email);"#,
            #"CREATE INDEX IF NOT EXISTS newsletter_subscribers_email_idx ON newsletter_subscribers (email);"#,
            #"CREATE INDEX IF NOT EXISTS newsletter_issues_newsletter_id_idx ON newsletter_issues (newsletter_id);"#,
            #"CREATE INDEX IF NOT EXISTS newsletter_deliveries_status_idx ON newsletter_deliveries (status);"#,
            #"CREATE INDEX IF NOT EXISTS newsletter_subscriptions_newsletter_idx ON newsletter_subscriptions (newsletter_id, status);"#
        ]
        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
