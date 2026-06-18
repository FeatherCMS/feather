import Infrastructure
import FeatherDatabase

public struct MetadataTableMigration: DatabaseMigration {

    public let connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        try await connection.run(
            query: #"""
                ALTER TABLE IF EXISTS metadata_entry
                RENAME TO web_metadata;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER INDEX IF EXISTS metadata_entry_reference_owner_idx
                RENAME TO web_metadata_reference_owner_idx;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER INDEX IF EXISTS metadata_entry_slug_idx
                RENAME TO web_metadata_slug_idx;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                CREATE TABLE IF NOT EXISTS web_metadata (
                    id TEXT PRIMARY KEY,
                    reference_type TEXT,
                    reference_id TEXT,
                    slug TEXT NOT NULL,
                    publication_date TIMESTAMPTZ,
                    expiration_date TIMESTAMPTZ,
                    status TEXT NOT NULL,
                    title TEXT NOT NULL DEFAULT '',
                    excerpt TEXT NOT NULL DEFAULT '',
                    image_url TEXT NOT NULL DEFAULT '',
                    title_override TEXT,
                    excerpt_override TEXT,
                    image_url_override TEXT,
                    canonical_url TEXT NOT NULL,
                    no_index BOOLEAN NOT NULL DEFAULT FALSE,
                    primary_keyword TEXT NOT NULL DEFAULT '',
                    css_code_injection TEXT NOT NULL,
                    javascript_code_injection TEXT NOT NULL,
                    structured_data_code_injection TEXT NOT NULL DEFAULT '',
                    created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                    updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
                );
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE web_metadata
                ADD COLUMN IF NOT EXISTS reference_type TEXT;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE web_metadata
                ADD COLUMN IF NOT EXISTS reference_id TEXT;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE web_metadata
                DROP CONSTRAINT IF EXISTS web_metadata_slug_key;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE web_metadata
                ADD COLUMN IF NOT EXISTS title_override TEXT;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE web_metadata
                ADD COLUMN IF NOT EXISTS excerpt_override TEXT;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE web_metadata
                ADD COLUMN IF NOT EXISTS image_url_override TEXT;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE web_metadata
                ADD COLUMN IF NOT EXISTS no_index BOOLEAN NOT NULL DEFAULT FALSE;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE web_metadata
                ADD COLUMN IF NOT EXISTS primary_keyword TEXT NOT NULL DEFAULT '';
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE web_metadata
                ADD COLUMN IF NOT EXISTS structured_data_code_injection TEXT NOT NULL DEFAULT '';
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE web_metadata
                DROP COLUMN IF EXISTS title;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE web_metadata
                DROP COLUMN IF EXISTS excerpt;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE web_metadata
                DROP COLUMN IF EXISTS image_url;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                CREATE UNIQUE INDEX IF NOT EXISTS web_metadata_reference_owner_idx
                ON web_metadata (reference_type, reference_id);
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                DROP INDEX IF EXISTS web_metadata_reference_slug_idx;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                CREATE UNIQUE INDEX IF NOT EXISTS web_metadata_slug_idx
                ON web_metadata (slug);
                """#
        ) { _ in }
    }
}
