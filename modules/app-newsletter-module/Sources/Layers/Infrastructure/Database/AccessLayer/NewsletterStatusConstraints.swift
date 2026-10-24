import FeatherDatabase

enum NewsletterStatusConstraints {
    static func apply(on connection: any DatabaseConnection) async throws {
        let queries: [DatabaseQuery] = [
            #"""
            DO $$ BEGIN
                IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'newsletter_subscriber_status_check') THEN
                    ALTER TABLE newsletter_subscriber
                    ADD CONSTRAINT newsletter_subscriber_status_check
                    CHECK (status IN ('subscribed', 'unsubscribed'));
                END IF;
            END $$;
            """#,
            #"""
            DO $$ BEGIN
                IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'newsletter_issue_status_check') THEN
                    ALTER TABLE newsletter_issue
                    ADD CONSTRAINT newsletter_issue_status_check
                    CHECK (status IN ('draft', 'scheduled', 'sending', 'sent', 'failed'));
                END IF;
            END $$;
            """#,
            #"""
            DO $$ BEGIN
                IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'newsletter_delivery_status_check') THEN
                    ALTER TABLE newsletter_delivery
                    ADD CONSTRAINT newsletter_delivery_status_check
                    CHECK (status IN ('pending', 'sent', 'failed', 'bounced'));
                END IF;
            END $$;
            """#,
        ]
        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
