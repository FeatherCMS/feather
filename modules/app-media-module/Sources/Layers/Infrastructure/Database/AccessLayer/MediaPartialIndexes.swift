import FeatherDatabase

enum MediaPartialIndexes {
    static func apply(on connection: any DatabaseConnection) async throws {
        let queries: [DatabaseQuery] = [
            #"CREATE UNIQUE INDEX IF NOT EXISTS media_asset_node_root_slug_idx ON media_asset_node (slug) WHERE parent_id IS NULL AND deleted_at IS NULL;"#,
            #"CREATE UNIQUE INDEX IF NOT EXISTS media_asset_node_parent_slug_idx ON media_asset_node (parent_id, slug) WHERE parent_id IS NOT NULL AND deleted_at IS NULL;"#,
            #"CREATE UNIQUE INDEX IF NOT EXISTS media_asset_node_absolute_slug_slug_idx ON media_asset_node (absolute_slug, slug) WHERE deleted_at IS NULL;"#,
            #"CREATE INDEX IF NOT EXISTS media_asset_node_parent_name_idx ON media_asset_node (parent_id, LOWER(name), id) WHERE deleted_at IS NULL;"#,
            #"CREATE INDEX IF NOT EXISTS media_asset_node_absolute_slug_pattern_idx ON media_asset_node (absolute_slug text_pattern_ops) WHERE deleted_at IS NULL;"#,
            #"CREATE INDEX IF NOT EXISTS media_variant_active_name_idx ON media_variant (name) WHERE is_active IS TRUE;"#,
            #"CREATE INDEX IF NOT EXISTS media_variant_processor_active_name_idx ON media_variant_processor (name) WHERE is_active IS TRUE;"#,
        ]
        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
