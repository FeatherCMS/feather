import FeatherDatabase
import FeatherInfrastructure

public struct TableMigration: DatabaseMigration {
    public let connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let queries: [DatabaseQuery] = [
            #"""
            CREATE TABLE IF NOT EXISTS web_page (
                id TEXT PRIMARY KEY,
                title TEXT NOT NULL,
                excerpt TEXT NOT NULL DEFAULT '',
                content TEXT NOT NULL,
                image_asset_id TEXT,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS web_page_title_idx
            ON web_page (title);
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS web_menu (
                id TEXT PRIMARY KEY,
                key TEXT NOT NULL UNIQUE,
                name TEXT NOT NULL,
                notes TEXT,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS web_menu_key_idx
            ON web_menu (key);
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS web_menu_item (
                id TEXT PRIMARY KEY,
                menu_id TEXT NOT NULL,
                label TEXT NOT NULL,
                url TEXT NOT NULL,
                priority INTEGER NOT NULL,
                is_blank BOOLEAN NOT NULL DEFAULT FALSE,
                permission TEXT NOT NULL,
                authentication TEXT NOT NULL DEFAULT 'any',
                notes TEXT,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                FOREIGN KEY(menu_id) REFERENCES web_menu(id) ON DELETE CASCADE
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS web_menu_item_menu_id_idx
            ON web_menu_item (menu_id);
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS web_metadata (
                id TEXT PRIMARY KEY,
                reference_type TEXT NOT NULL,
                reference_id TEXT NOT NULL,
                template TEXT NOT NULL DEFAULT 'default',
                slug TEXT NOT NULL,
                publication_date TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                expiration_date TIMESTAMPTZ,
                status TEXT NOT NULL,
                title_override TEXT,
                excerpt_override TEXT,
                image_url_override TEXT,
                canonical_url TEXT,
                no_index BOOLEAN NOT NULL DEFAULT FALSE,
                primary_keyword TEXT,
                css_code_injection TEXT,
                javascript_code_injection TEXT,
                structured_data_code_injection TEXT,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE UNIQUE INDEX IF NOT EXISTS web_metadata_reference_owner_idx
            ON web_metadata (reference_type, reference_id);
            """#,
            #"""
            CREATE UNIQUE INDEX IF NOT EXISTS web_metadata_slug_idx
            ON web_metadata (slug);
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
