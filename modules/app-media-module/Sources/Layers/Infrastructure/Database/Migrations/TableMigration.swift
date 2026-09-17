import FeatherDatabase
import FeatherInfrastructure

public struct TableMigration: DatabaseMigration {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func apply(on connection: any DatabaseConnection) async throws {
        let queries: [DatabaseQuery] = [
            // Clean-install media schema. Legacy media tables are removed.
            #"DROP TABLE IF EXISTS media_processor_asset;"#,
            #"DROP TABLE IF EXISTS media_asset_variant;"#,
            #"DROP TABLE IF EXISTS media_asset_node_file;"#,
            #"DROP TABLE IF EXISTS media_asset_node_folder;"#,
            #"DROP TABLE IF EXISTS media_asset_storage_object;"#,
            #"DROP TABLE IF EXISTS media_asset_node;"#,
            #"DROP TABLE IF EXISTS media_asset;"#,
            #"DROP TABLE IF EXISTS media_folder;"#,

            #"""
            CREATE TABLE IF NOT EXISTS media_asset_node (
                id TEXT PRIMARY KEY,
                parent_id TEXT REFERENCES media_asset_node(id) ON DELETE CASCADE,
                name TEXT NOT NULL,
                slug TEXT NOT NULL,
                slug_path TEXT NOT NULL UNIQUE,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                deleted_at TIMESTAMPTZ
            );
            """#,
            #"""
            CREATE UNIQUE INDEX IF NOT EXISTS media_asset_node_root_slug_idx
            ON media_asset_node (slug)
            WHERE parent_id IS NULL AND deleted_at IS NULL;
            """#,
            #"""
            CREATE UNIQUE INDEX IF NOT EXISTS media_asset_node_parent_slug_idx
            ON media_asset_node (parent_id, slug)
            WHERE parent_id IS NOT NULL AND deleted_at IS NULL;
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_parent_id_idx
            ON media_asset_node (parent_id);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_slug_path_idx
            ON media_asset_node (slug_path);
            """#,

            #"""
            CREATE TABLE IF NOT EXISTS media_asset_storage_object (
                id TEXT PRIMARY KEY,
                object_key TEXT NOT NULL UNIQUE,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                deleted_at TIMESTAMPTZ
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS media_asset_node_folder (
                node_id TEXT PRIMARY KEY REFERENCES media_asset_node(id) ON DELETE CASCADE,
                asset_count INTEGER NOT NULL DEFAULT 0,
                total_size_bytes BIGINT NOT NULL DEFAULT 0
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS media_asset_node_file (
                node_id TEXT PRIMARY KEY REFERENCES media_asset_node(id) ON DELETE CASCADE,
                storage_object_id TEXT NOT NULL UNIQUE REFERENCES media_asset_storage_object(id) ON DELETE RESTRICT,
                extension TEXT NOT NULL,
                content_type TEXT NOT NULL,
                size_bytes BIGINT NOT NULL,
                status TEXT NOT NULL,
                title TEXT,
                alt_text TEXT
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_file_status_idx
            ON media_asset_node_file (status);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_file_extension_idx
            ON media_asset_node_file (extension);
            """#,

            #"""
            CREATE TABLE IF NOT EXISTS media_processor (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL UNIQUE,
                match_extensions TEXT NOT NULL,
                command_template TEXT NOT NULL,
                is_required BOOLEAN NOT NULL DEFAULT TRUE,
                is_active BOOLEAN NOT NULL DEFAULT TRUE,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS media_asset_variant (
                id TEXT PRIMARY KEY,
                asset_id TEXT NOT NULL REFERENCES media_asset_node_file(node_id) ON DELETE CASCADE,
                processor_id TEXT NOT NULL REFERENCES media_processor(id) ON DELETE CASCADE,
                name TEXT NOT NULL,
                storage_object_id TEXT NOT NULL UNIQUE REFERENCES media_asset_storage_object(id) ON DELETE RESTRICT,
                extension TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                UNIQUE(asset_id, processor_id),
                UNIQUE(asset_id, name)
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_variant_asset_id_idx
            ON media_asset_variant (asset_id);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_variant_processor_id_idx
            ON media_asset_variant (processor_id);
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
