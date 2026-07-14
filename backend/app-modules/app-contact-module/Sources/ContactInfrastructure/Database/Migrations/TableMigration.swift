import FeatherDatabase
import Infrastructure

public struct TableMigration: DatabaseMigration {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func apply(on connection: any DatabaseConnection) async throws {
        try await connection.run(query: #"""
            CREATE TABLE IF NOT EXISTS contact_form (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                success_message TEXT NOT NULL DEFAULT '',
                failure_message TEXT NOT NULL DEFAULT '',
                redirect_url TEXT,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#) { _ in }

        try await connection.run(query: #"""
            CREATE TABLE IF NOT EXISTS contact_form_mail (
                id TEXT PRIMARY KEY,
                form_id TEXT NOT NULL,
                mail_from TEXT NOT NULL,
                mail_to TEXT NOT NULL,
                subject TEXT NOT NULL,
                additional_headers TEXT NOT NULL DEFAULT '',
                message_body TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                FOREIGN KEY(form_id) REFERENCES contact_form(id) ON DELETE CASCADE
            );
            """#) { _ in }

        try await connection.run(query: #"CREATE INDEX IF NOT EXISTS contact_form_mail_form_id_idx ON contact_form_mail (form_id, id);"#) { _ in }

        let queries: [DatabaseQuery] = [
            #"""
            CREATE TABLE IF NOT EXISTS contact_form_field (
                id TEXT PRIMARY KEY,
                key TEXT NOT NULL,
                type TEXT NOT NULL CHECK (type IN ('text', 'textarea', 'select', 'radio', 'toggle')),
                label TEXT NOT NULL,
                allowed_values JSONB NOT NULL DEFAULT '[]'::jsonb,
                is_required BOOLEAN NOT NULL DEFAULT FALSE,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                UNIQUE (key),
                CHECK (
                    (type IN ('select', 'radio') AND jsonb_array_length(allowed_values) > 0)
                    OR (type IN ('text', 'textarea', 'toggle') AND allowed_values = '[]'::jsonb)
                )
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS contact_form_field_key_idx
            ON contact_form_field (key);
            """#,
            #"""
            INSERT INTO contact_form_field (
                id, key, type, label, allowed_values, is_required,
                created_at, updated_at
            )
            VALUES
                ('F6A2kqP9dW3xR7mN8tYcL', 'email', 'text', 'Email', '[]'::jsonb, TRUE, NOW(), NOW()),
                ('nL9Y4cWQ2mR7xK8vP3dTq', 'firstName', 'text', 'First name', '[]'::jsonb, FALSE, NOW(), NOW()),
                ('z7Qk2Vn9Xr4Lm8Pc1HaWs', 'lastName', 'text', 'Last name', '[]'::jsonb, FALSE, NOW(), NOW()),
                ('p4Xr8Kc2Vn7Lm9Qw3HaTy', 'message', 'textarea', 'Message', '[]'::jsonb, FALSE, NOW(), NOW())
            ON CONFLICT (key) DO NOTHING;
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS contact_form_form_field (
                form_id TEXT NOT NULL,
                field_id TEXT NOT NULL,
                position INTEGER NOT NULL DEFAULT 0,
                PRIMARY KEY (form_id, field_id),
                FOREIGN KEY(form_id) REFERENCES contact_form(id) ON DELETE CASCADE,
                FOREIGN KEY(field_id) REFERENCES contact_form_field(id) ON DELETE CASCADE
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS contact_form_form_field_form_id_idx
            ON contact_form_form_field (form_id, position);
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS contact_form_submission (
                id TEXT PRIMARY KEY,
                form_id TEXT NOT NULL,
                "values" JSONB NOT NULL,
                items_snapshot JSONB NOT NULL,
                metadata JSONB,
                status TEXT NOT NULL DEFAULT 'received'
                    CHECK (status IN ('received', 'processed', 'spam', 'failed')),
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                FOREIGN KEY(form_id) REFERENCES contact_form(id) ON DELETE CASCADE
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS contact_form_submission_form_id_idx
            ON contact_form_submission (form_id, created_at DESC);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS contact_form_submission_status_idx
            ON contact_form_submission (status);
            """#
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
