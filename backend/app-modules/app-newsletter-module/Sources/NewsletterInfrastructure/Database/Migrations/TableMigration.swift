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
            CREATE TABLE IF NOT EXISTS newsletter_subscriber_global (
                id TEXT PRIMARY KEY,
                email TEXT NOT NULL,
                first_name TEXT NOT NULL DEFAULT '',
                last_name TEXT NOT NULL DEFAULT '',
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS newsletter_campaign (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS newsletter_subscriber (
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
                FOREIGN KEY(newsletter_id) REFERENCES newsletter_campaign(id) ON DELETE CASCADE
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS newsletter_issue (
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
                FOREIGN KEY(newsletter_id) REFERENCES newsletter_campaign(id) ON DELETE CASCADE
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS newsletter_delivery (
                issue_id TEXT NOT NULL,
                newsletter_id TEXT NOT NULL,
                subscriber_email TEXT NOT NULL,
                status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'sent', 'failed', 'bounced')),
                sent_date TIMESTAMPTZ,
                failure_reason TEXT,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                PRIMARY KEY (issue_id, subscriber_email),
                FOREIGN KEY(issue_id, newsletter_id) REFERENCES newsletter_issue(id, newsletter_id)
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS newsletter_subscription (
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
                FOREIGN KEY(subscriber_id) REFERENCES newsletter_subscriber_global(id) ON DELETE CASCADE,
                FOREIGN KEY(newsletter_id) REFERENCES newsletter_campaign(id) ON DELETE CASCADE
            );
            """#,
            #"CREATE UNIQUE INDEX IF NOT EXISTS newsletter_subscriber_global_email_idx ON newsletter_subscriber_global (lower(trim(email)));"#,
            #"CREATE INDEX IF NOT EXISTS newsletter_subscriber_email_idx ON newsletter_subscriber (email);"#,
            #"CREATE INDEX IF NOT EXISTS newsletter_issue_newsletter_id_idx ON newsletter_issue (newsletter_id);"#,
            #"CREATE INDEX IF NOT EXISTS newsletter_delivery_status_idx ON newsletter_delivery (status);"#,
            #"CREATE INDEX IF NOT EXISTS newsletter_subscription_newsletter_idx ON newsletter_subscription (newsletter_id, status);"#
        ]
        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
