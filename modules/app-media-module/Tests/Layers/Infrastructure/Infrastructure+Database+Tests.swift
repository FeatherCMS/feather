import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import MediaModule
import Testing

@testable import FeatherDBAL
@testable import MediaInfrastructure

private enum QueryKey: DatabaseQueryKey {
    case migration
}

@Suite
struct InfrastructureDatabaseTests {
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
        #expect(queries[.migration]?.count == 20)
        for index in [
            "media_asset_node_root_slug_idx",
            "media_asset_node_parent_slug_idx",
            "media_asset_node_absolute_slug_slug_idx",
            "media_asset_node_parent_name_idx",
            "media_asset_node_absolute_slug_pattern_idx",
            "media_variant_active_name_idx",
            "media_variant_processor_active_name_idx",
        ] {
            #expect(
                queries[.migration]?.contains { $0.sql.contains(index) } == true
            )
        }
    }

    @Test
    func tableSchemasDeclareColumnsConstraintsDefaultsAndIndexes() {
        let assetNode = Asset.Node.Table.tableCreationSchema
        let assetFolder = Asset.Folder.Table.tableCreationSchema
        let storageObject = StorageObject.Table.tableCreationSchema
        let assetFile = Asset.File.Table.tableCreationSchema
        let variant = Variant.Table.tableCreationSchema
        let variantProcessor = Variant.Processor.Table.tableCreationSchema
        let assetFileVariant = Asset.File.Variant.Table.tableCreationSchema

        #expect(assetNode.columns.map(\.name) == [
            "id", "parent_id", "name", "slug", "absolute_slug", "created_at",
            "updated_at", "deleted_at",
        ])
        #expect(assetNode.columns[1].type == .string)
        #expect(assetNode.columns[1].constraints.isEmpty)
        for column in [
            assetNode.columns[2],
            assetNode.columns[3],
            assetNode.columns[4],
            assetNode.columns[5],
            assetNode.columns[6],
        ] {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
        #expect(assetNode.constraints.contains {
            guard case .primaryKey(let columns) = $0 else { return false }
            return columns.map(\.name) == ["id"]
        })
        #expect(assetNode.columns[4].constraints.contains {
            if case .notNull = $0 { true } else { false }
        })
        #expect(assetNode.columns[4].constraints.contains {
            guard case .default(let value) = $0 else { return false }
            guard case .string(let actual) = value.storage else { return false }
            return actual.isEmpty
        })
        for column in [assetNode.columns[5], assetNode.columns[6]] {
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                if case .currentTimestamp = value.storage { return true }
                return false
            })
        }
        #expect(
            assetNode.indexes.map(\.name) == ["media_asset_node_parent_id_idx"]
        )
        #expect(assetNode.constraints.contains {
            guard
                case .foreignKey(
                    let columns,
                    let table,
                    let referencedColumns,
                    let onDelete,
                    _
                ) = $0
            else { return false }
            guard case .cascade? = onDelete else { return false }
            return columns.map(\.name) == ["parent_id"]
                && table == Asset.Node.Table.name
                && referencedColumns.map(\.name) == ["id"]
        })

        #expect(assetFolder.columns.map(\.name) == [
            "asset_node_id", "asset_count", "total_size_bytes",
        ])
        #expect(assetFolder.constraints.contains {
            guard case .primaryKey(let columns) = $0 else { return false }
            return columns.map(\.name) == ["asset_node_id"]
        })
        for column in [assetFolder.columns[1], assetFolder.columns[2]] {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
        for column in [assetFolder.columns[1], assetFolder.columns[2]] {
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                guard case .integer(let actual) = value.storage else { return false }
                return actual == 0
            })
        }
        #expect(assetFolder.constraints.contains {
            guard
                case .foreignKey(
                    let columns,
                    let table,
                    let referencedColumns,
                    let onDelete,
                    _
                ) = $0
            else { return false }
            guard case .cascade? = onDelete else { return false }
            return columns.map(\.name) == ["asset_node_id"]
                && table == Asset.Node.Table.name
                && referencedColumns.map(\.name) == ["id"]
        })

        #expect(storageObject.columns.map(\.name) == [
            "id", "key", "extension", "content_type", "size_in_bytes", "created_at",
        ])
        #expect(storageObject.constraints.contains {
            guard case .primaryKey(let columns) = $0 else { return false }
            return columns.map(\.name) == ["id"]
        })
        for column in [
            storageObject.columns[1],
            storageObject.columns[2],
            storageObject.columns[3],
            storageObject.columns[4],
            storageObject.columns[5],
        ] {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
        #expect(storageObject.columns[5].constraints.contains {
            guard case .default(let value) = $0 else { return false }
            if case .currentTimestamp = value.storage { return true }
            return false
        })
        #expect(
            storageObject.indexes.map(\.name)
                == ["media_storage_object_extension_idx"]
        )

        #expect(assetFile.columns.map(\.name) == [
            "asset_node_id", "storage_object_id", "status", "title", "alt_text",
        ])
        #expect(assetFile.constraints.contains {
            guard case .primaryKey(let columns) = $0 else { return false }
            return columns.map(\.name) == ["asset_node_id"]
        })
        #expect(assetFile.columns[1].constraints.contains {
            if case .unique = $0 { true } else { false }
        })
        #expect(
            assetFile.indexes.map(\.name)
                == ["media_asset_node_file_status_idx"]
        )
        #expect(assetFile.constraints.filter {
            if case .foreignKey = $0 { true } else { false }
        }.count == 2)
        #expect(assetFile.constraints.contains {
            guard
                case .foreignKey(
                    let columns,
                    let table,
                    let referencedColumns,
                    let onDelete,
                    _
                ) = $0
            else { return false }
            guard case .cascade? = onDelete else { return false }
            return columns.map(\.name) == ["asset_node_id"]
                && table == Asset.Node.Table.name
                && referencedColumns.map(\.name) == ["id"]
        })
        #expect(assetFile.constraints.contains {
            guard
                case .foreignKey(
                    let columns,
                    let table,
                    let referencedColumns,
                    let onDelete,
                    _
                ) = $0
            else { return false }
            if case nil = onDelete {} else { return false }
            return columns.map(\.name) == ["storage_object_id"]
                && table == StorageObject.Table.name
                && referencedColumns.map(\.name) == ["id"]
        })
        for column in [assetFile.columns[1], assetFile.columns[2]] {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }

        #expect(variant.columns.map(\.name) == [
            "id", "variant_key", "name", "is_required", "is_active", "created_at",
            "updated_at",
        ])
        #expect(variant.constraints.contains {
            guard case .primaryKey(let columns) = $0 else { return false }
            return columns.map(\.name) == ["id"]
        })
        for column in [variant.columns[1], variant.columns[2]] {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
            #expect(column.constraints.contains {
                if case .unique = $0 { true } else { false }
            })
        }
        for column in [
            variant.columns[3],
            variant.columns[4],
            variant.columns[5],
            variant.columns[6],
        ] {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
        for column in [variant.columns[3], variant.columns[4]] {
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                guard case .boolean(let actual) = value.storage else { return false }
                return actual
            })
        }
        for column in [variant.columns[5], variant.columns[6]] {
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                if case .currentTimestamp = value.storage { return true }
                return false
            })
        }

        #expect(variantProcessor.columns.map(\.name) == [
            "id", "variant_id", "name", "match_extensions", "command_template",
            "is_active", "created_at", "updated_at",
        ])
        #expect(variantProcessor.constraints.contains {
            guard case .primaryKey(let columns) = $0 else { return false }
            return columns.map(\.name) == ["id"]
        })
        #expect(variantProcessor.columns[3].type == .text)
        #expect(variantProcessor.columns[4].type == .text)
        for column in [
            variantProcessor.columns[1],
            variantProcessor.columns[2],
            variantProcessor.columns[3],
            variantProcessor.columns[4],
            variantProcessor.columns[5],
            variantProcessor.columns[6],
            variantProcessor.columns[7],
        ] {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
        #expect(variantProcessor.columns[5].constraints.contains {
            guard case .default(let value) = $0 else { return false }
            guard case .boolean(let actual) = value.storage else { return false }
            return actual
        })
        for column in [variantProcessor.columns[6], variantProcessor.columns[7]] {
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                if case .currentTimestamp = value.storage { return true }
                return false
            })
        }
        #expect(variantProcessor.constraints.contains {
            guard case .unique(let columns) = $0 else { return false }
            return columns.map(\.name) == ["variant_id", "name"]
        })
        #expect(variantProcessor.constraints.contains {
            guard case .unique(let columns) = $0 else { return false }
            return columns.map(\.name) == ["variant_id", "id"]
        })
        #expect(variantProcessor.constraints.contains {
            guard
                case .foreignKey(
                    let columns,
                    let table,
                    let referencedColumns,
                    let onDelete,
                    _
                ) = $0
            else { return false }
            guard case .cascade? = onDelete else { return false }
            return columns.map(\.name) == ["variant_id"]
                && table == Variant.Table.name
                && referencedColumns.map(\.name) == ["id"]
        })

        #expect(assetFileVariant.columns.map(\.name) == [
            "id", "asset_node_file_id", "variant_id", "variant_processor_id",
            "storage_object_id", "created_at",
        ])
        #expect(assetFileVariant.constraints.contains {
            guard case .primaryKey(let columns) = $0 else { return false }
            return columns.map(\.name) == ["id"]
        })
        for column in [
            assetFileVariant.columns[1],
            assetFileVariant.columns[2],
            assetFileVariant.columns[3],
            assetFileVariant.columns[4],
            assetFileVariant.columns[5],
        ] {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
        #expect(assetFileVariant.columns[5].constraints.contains {
            guard case .default(let value) = $0 else { return false }
            if case .currentTimestamp = value.storage { return true }
            return false
        })
        #expect(assetFileVariant.constraints.contains {
            guard case .unique(let columns) = $0 else { return false }
            return columns.map(\.name) == ["asset_node_file_id", "variant_id"]
        })
        #expect(assetFileVariant.constraints.contains {
            guard case .unique(let columns) = $0 else { return false }
            return columns.map(\.name) == ["storage_object_id"]
        })
        #expect(assetFileVariant.constraints.filter {
            if case .foreignKey = $0 { true } else { false }
        }.count == 4)
        #expect(assetFileVariant.constraints.contains {
            guard
                case .foreignKey(
                    let columns,
                    let table,
                    let referencedColumns,
                    let onDelete,
                    _
                ) = $0
            else { return false }
            guard case .cascade? = onDelete else { return false }
            return columns.map(\.name) == ["asset_node_file_id"]
                && table == Asset.File.Table.name
                && referencedColumns.map(\.name) == ["asset_node_id"]
        })
        #expect(assetFileVariant.constraints.contains {
            guard
                case .foreignKey(
                    let columns,
                    let table,
                    let referencedColumns,
                    let onDelete,
                    _
                ) = $0
            else { return false }
            guard case .cascade? = onDelete else { return false }
            return columns.map(\.name) == ["variant_id"]
                && table == Variant.Table.name
                && referencedColumns.map(\.name) == ["id"]
        })
        #expect(assetFileVariant.constraints.contains {
            guard
                case .foreignKey(
                    let columns,
                    let table,
                    let referencedColumns,
                    let onDelete,
                    _
                ) = $0
            else { return false }
            guard case .cascade? = onDelete else { return false }
            return columns.map(\.name) == ["storage_object_id"]
                && table == StorageObject.Table.name
                && referencedColumns.map(\.name) == ["id"]
        })
        #expect(assetFileVariant.constraints.contains {
            guard
                case .foreignKey(
                    let columns,
                    let table,
                    let referencedColumns,
                    let onDelete,
                    _
                ) = $0
            else { return false }
            guard case .cascade? = onDelete else { return false }
            return columns.map(\.name) == ["variant_id", "variant_processor_id"]
                && table == Variant.Processor.Table.name
                && referencedColumns.map(\.name) == ["variant_id", "id"]
        })
        #expect(assetFileVariant.indexes.map(\.name) == [
            "media_asset_node_file_variant_asset_created_idx",
            "media_asset_node_file_variant_variant_id_idx",
            "media_asset_node_file_variant_processor_id_idx",
        ])
    }
}
