import Infrastructure
import FeatherDatabase

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
                notes TEXT NOT NULL,
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
                notes TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                FOREIGN KEY(menu_id) REFERENCES web_menu(id) ON DELETE CASCADE
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS web_menu_item_menu_id_idx
            ON web_menu_item (menu_id);
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
