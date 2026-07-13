import FeatherDatabase
import Infrastructure

/// Ensures form fields and submissions exist for databases created before the
/// Contact v1 schema was consolidated into `TableMigration`.
public struct ContactFormTablesMigration: DatabaseMigration {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func apply(on connection: any DatabaseConnection) async throws {
        let queries: [DatabaseQuery] = [
            #"""
            CREATE TABLE IF NOT EXISTS contact_form_items (
                id TEXT PRIMARY KEY,
                form_id TEXT NOT NULL,
                key TEXT NOT NULL,
                type TEXT NOT NULL CHECK (type IN ('text', 'textarea', 'select', 'radio', 'toggle')),
                label TEXT NOT NULL,
                allowed_values JSONB NOT NULL DEFAULT '[]'::jsonb,
                is_required BOOLEAN NOT NULL DEFAULT FALSE,
                position INTEGER NOT NULL DEFAULT 0,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                UNIQUE (form_id, key),
                FOREIGN KEY(form_id) REFERENCES contact_forms(id) ON DELETE CASCADE,
                CHECK (
                    (type IN ('select', 'radio') AND jsonb_array_length(allowed_values) > 0)
                    OR (type IN ('text', 'textarea', 'toggle') AND allowed_values = '[]'::jsonb)
                )
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS contact_form_items_form_id_idx
            ON contact_form_items (form_id, position);
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS contact_form_submissions (
                id TEXT PRIMARY KEY,
                form_id TEXT NOT NULL,
                "values" JSONB NOT NULL,
                items_snapshot JSONB NOT NULL,
                metadata JSONB,
                status TEXT NOT NULL DEFAULT 'received'
                    CHECK (status IN ('received', 'processed', 'spam', 'failed')),
                submitted_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                FOREIGN KEY(form_id) REFERENCES contact_forms(id) ON DELETE CASCADE
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS contact_form_submissions_form_id_idx
            ON contact_form_submissions (form_id, submitted_at DESC);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS contact_form_submissions_status_idx
            ON contact_form_submissions (status);
            """#
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
