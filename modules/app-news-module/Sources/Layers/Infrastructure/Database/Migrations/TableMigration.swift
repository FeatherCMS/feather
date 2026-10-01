public import FeatherDatabase
public import FeatherInfrastructure

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
        try await applyTableMigration(on: connection)
    }

    private func applyTableMigration(
        on connection: any DatabaseConnection
    ) async throws {
        let queries: [DatabaseQuery] = [
            #"""
            CREATE TABLE IF NOT EXISTS news_article (
                id TEXT PRIMARY KEY,
                title TEXT NOT NULL,
                excerpt TEXT NOT NULL DEFAULT '',
                content TEXT NOT NULL,
                image_asset_id TEXT REFERENCES media_asset_node_file(asset_node_id) ON DELETE SET NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS news_article_title_idx
            ON news_article (title);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS news_article_image_asset_id_idx
            ON news_article (image_asset_id);
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS news_category (
                id TEXT PRIMARY KEY,
                title TEXT NOT NULL,
                excerpt TEXT NOT NULL DEFAULT '',
                content TEXT NOT NULL,
                image_asset_id TEXT REFERENCES media_asset_node_file(asset_node_id) ON DELETE SET NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS news_category_title_idx
            ON news_category (title);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS news_category_image_asset_id_idx
            ON news_category (image_asset_id);
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS news_article_category (
                article_id TEXT NOT NULL REFERENCES news_article(id)
                    ON DELETE CASCADE,
                category_id TEXT NOT NULL REFERENCES news_category(id)
                    ON DELETE CASCADE,
                PRIMARY KEY (article_id, category_id)
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS news_article_category_category_id_idx
            ON news_article_category (category_id);
            """#,
        ]
        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }

}
