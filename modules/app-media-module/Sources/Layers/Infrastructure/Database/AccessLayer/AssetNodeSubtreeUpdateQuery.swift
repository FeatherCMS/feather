import FeatherDatabase

struct AssetNodeSubtreeUpdateQuery {
    let connection: any DatabaseConnection

    func update(
        oldSlugPath: String,
        newSlugPath: String
    ) async throws {
        _ = try await connection.run(
            query: #"""
                UPDATE media_asset_node
                SET absolute_slug = \#(newSlugPath) || SUBSTRING(absolute_slug FROM \#(oldSlugPath.count + 1)),
                    updated_at = NOW()
                WHERE (absolute_slug = \#(oldSlugPath) OR absolute_slug LIKE \#(oldSlugPath + "/%"))
                  AND deleted_at IS NULL;
                """#
        ) { _ in }
    }
}
