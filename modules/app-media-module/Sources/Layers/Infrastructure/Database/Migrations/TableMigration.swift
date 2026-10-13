public import FeatherDatabase
public import FeatherInfrastructure

public struct TableMigration: DatabaseMigration {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func apply(on connection: any DatabaseConnection) async throws {
        let queries: [DatabaseQuery] = [
            #"""
            CREATE TABLE IF NOT EXISTS media_asset_node (
                id TEXT PRIMARY KEY,
                parent_id TEXT REFERENCES media_asset_node(id) ON DELETE CASCADE,
                name TEXT NOT NULL,
                slug TEXT NOT NULL,
                absolute_slug TEXT NOT NULL DEFAULT '',
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
            CREATE UNIQUE INDEX IF NOT EXISTS media_asset_node_absolute_slug_slug_idx
            ON media_asset_node (absolute_slug, slug)
            WHERE deleted_at IS NULL;
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_parent_id_idx
            ON media_asset_node (parent_id);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_parent_name_idx
            ON media_asset_node (parent_id, LOWER(name), id)
            WHERE deleted_at IS NULL;
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_absolute_slug_pattern_idx
            ON media_asset_node (absolute_slug text_pattern_ops)
            WHERE deleted_at IS NULL;
            """#,

            #"""
            CREATE TABLE IF NOT EXISTS media_asset_node_folder (
                asset_node_id TEXT PRIMARY KEY REFERENCES media_asset_node(id) ON DELETE CASCADE,
                asset_count INTEGER NOT NULL DEFAULT 0,
                total_size_bytes BIGINT NOT NULL DEFAULT 0
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS media_storage_object (
                id TEXT PRIMARY KEY,
                key TEXT NOT NULL,
                extension TEXT NOT NULL,
                content_type TEXT NOT NULL,
                size_in_bytes BIGINT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS media_asset_node_file (
                asset_node_id TEXT PRIMARY KEY REFERENCES media_asset_node(id) ON DELETE CASCADE,
                storage_object_id TEXT NOT NULL UNIQUE REFERENCES media_storage_object(id),
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
            CREATE INDEX IF NOT EXISTS media_storage_object_extension_idx
            ON media_storage_object (extension);
            """#,

            #"""
            CREATE TABLE IF NOT EXISTS media_variant (
                id TEXT PRIMARY KEY,
                variant_key TEXT NOT NULL UNIQUE,
                name TEXT NOT NULL UNIQUE,
                is_required BOOLEAN NOT NULL DEFAULT TRUE,
                is_active BOOLEAN NOT NULL DEFAULT TRUE,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_variant_active_name_idx
            ON media_variant (name)
            WHERE is_active IS TRUE;
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS media_variant_processor (
                id TEXT PRIMARY KEY,
                variant_id TEXT NOT NULL REFERENCES media_variant(id) ON DELETE CASCADE,
                name TEXT NOT NULL,
                match_extensions TEXT NOT NULL,
                command_template TEXT NOT NULL,
                is_active BOOLEAN NOT NULL DEFAULT TRUE,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                UNIQUE(variant_id, name),
                UNIQUE(variant_id, id)
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_variant_processor_active_name_idx
            ON media_variant_processor (name)
            WHERE is_active IS TRUE;
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS media_asset_node_file_variant (
                id TEXT PRIMARY KEY,
                asset_node_file_id TEXT NOT NULL REFERENCES media_asset_node_file(asset_node_id) ON DELETE CASCADE,
                variant_id TEXT NOT NULL REFERENCES media_variant(id) ON DELETE CASCADE,
                variant_processor_id TEXT NOT NULL,
                storage_object_id TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                UNIQUE(asset_node_file_id, variant_id),
                UNIQUE(storage_object_id),
                FOREIGN KEY (storage_object_id)
                    REFERENCES media_storage_object(id)
                    ON DELETE CASCADE,
                FOREIGN KEY (variant_id, variant_processor_id)
                    REFERENCES media_variant_processor(variant_id, id)
                    ON DELETE CASCADE
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_file_variant_asset_created_idx
            ON media_asset_node_file_variant (asset_node_file_id, created_at, id);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_file_variant_variant_id_idx
            ON media_asset_node_file_variant (variant_id);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_file_variant_processor_id_idx
            ON media_asset_node_file_variant (variant_processor_id);
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
