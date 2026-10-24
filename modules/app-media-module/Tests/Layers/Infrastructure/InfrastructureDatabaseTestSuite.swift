import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import Testing

@testable import MediaInfrastructure

private enum QueryKey: DatabaseQueryKey {
    case migration
}

@Suite
struct InfrastructureDatabaseTestSuite {
    @Test
    func migrationCreatesExpectedMediaSchema() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: Array(
                repeating: .init(key: .migration),
                count: 20
            )
        )
        let migration = TableMigration(
            connection: connection,
            platform: MockDatabasePlatform()
        )

        try await migration.apply(on: connection)
        try await connection.assertAllResponsesConsumed()

        let queries = await connection.executedQueries()
        let sql = queries.values.flatMap { $0 }.map(\.sql)
            .joined(
                separator: "\n"
            )
        let normalizedSQL = String(sql.filter { $0 != "\"" })

        for table in [
            "media_asset_node",
            "media_asset_node_folder",
            "media_storage_object",
            "media_asset_node_file",
            "media_variant",
            "media_variant_processor",
            "media_asset_node_file_variant",
        ] {
            #expect(
                normalizedSQL.contains("CREATE TABLE IF NOT EXISTS \(table) (")
            )
        }

        for column in [
            "parent_id TEXT",
            "absolute_slug TEXT NOT NULL DEFAULT ''",
            "asset_count INTEGER NOT NULL DEFAULT 0",
            "total_size_bytes INTEGER NOT NULL DEFAULT 0",
            "storage_object_id TEXT NOT NULL UNIQUE",
            "variant_key TEXT NOT NULL UNIQUE",
            "is_required BOOLEAN NOT NULL DEFAULT TRUE",
            "is_active BOOLEAN NOT NULL DEFAULT TRUE",
            "match_extensions TEXT NOT NULL",
            "command_template TEXT NOT NULL",
            "UNIQUE (variant_id, name)",
            "UNIQUE (variant_id, id)",
            "UNIQUE (asset_node_file_id, variant_id)",
            "UNIQUE (storage_object_id)",
            "FOREIGN KEY (parent_id) REFERENCES media_asset_node (id) ON DELETE CASCADE",
            "FOREIGN KEY (storage_object_id) REFERENCES media_storage_object (id)",
            "FOREIGN KEY (variant_id, variant_processor_id)",
        ] {
            #expect(normalizedSQL.contains(column))
        }

        for index in [
            "media_asset_node_root_slug_idx",
            "media_asset_node_parent_slug_idx",
            "media_asset_node_absolute_slug_slug_idx",
        ] {
            #expect(
                normalizedSQL.contains("CREATE UNIQUE INDEX IF NOT EXISTS \(index)")
            )
        }

        for index in [
            "media_asset_node_parent_id_idx",
            "media_asset_node_parent_name_idx",
            "media_asset_node_absolute_slug_pattern_idx",
            "media_asset_node_file_status_idx",
            "media_storage_object_extension_idx",
            "media_variant_active_name_idx",
            "media_variant_processor_active_name_idx",
            "media_asset_node_file_variant_asset_created_idx",
            "media_asset_node_file_variant_variant_id_idx",
            "media_asset_node_file_variant_processor_id_idx",
        ] {
            #expect(
                normalizedSQL.contains("CREATE INDEX \(index)")
                    || normalizedSQL.contains("CREATE INDEX IF NOT EXISTS \(index)")
            )
        }

        #expect(normalizedSQL.contains("created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP"))
        #expect(normalizedSQL.contains("updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP"))
    }
}
