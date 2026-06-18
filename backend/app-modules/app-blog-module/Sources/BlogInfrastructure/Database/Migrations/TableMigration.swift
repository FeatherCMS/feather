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
            CREATE TABLE IF NOT EXISTS blog_post (
                id TEXT PRIMARY KEY,
                title TEXT NOT NULL,
                excerpt TEXT NOT NULL DEFAULT '',
                content TEXT NOT NULL,
                image_asset_id TEXT,
                author_ids TEXT NOT NULL DEFAULT '[]',
                tag_ids TEXT NOT NULL DEFAULT '[]',
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS blog_post_title_idx
            ON blog_post (title);
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS blog_tag (
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
            CREATE INDEX IF NOT EXISTS blog_tag_title_idx
            ON blog_tag (title);
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS blog_author (
                id TEXT PRIMARY KEY,
                key TEXT NOT NULL UNIQUE,
                name TEXT NOT NULL,
                notes TEXT NOT NULL,
                excerpt TEXT NOT NULL DEFAULT '',
                profile_image_asset_id TEXT,
                content TEXT NOT NULL DEFAULT '',
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS blog_author_key_idx
            ON blog_author (key);
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS blog_author_link (
                id TEXT PRIMARY KEY,
                author_id TEXT NOT NULL,
                label TEXT NOT NULL,
                url TEXT NOT NULL,
                priority INTEGER NOT NULL,
                is_blank BOOLEAN NOT NULL DEFAULT FALSE,
                permission TEXT NOT NULL,
                notes TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                FOREIGN KEY(author_id) REFERENCES blog_author(id) ON DELETE CASCADE
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS blog_author_link_author_id_idx
            ON blog_author_link (author_id);
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
