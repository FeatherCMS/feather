import FeatherDBAL
import MediaModule

extension Asset.File.Variant.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(name: columns.id.name, type: .string),
                .init(name: columns.assetNodeFileId.name, type: .string, constraints: [.notNull]),
                .init(name: columns.variantId.name, type: .string, constraints: [.notNull]),
                .init(name: columns.variantProcessorId.name, type: .string, constraints: [.notNull]),
                .init(name: columns.storageObjectId.name, type: .string, constraints: [.notNull]),
                .init(name: columns.createdAt.name, type: .timestamp, constraints: [.notNull, .default(.currentTimestamp)]),
            ],
            constraints: [
                .primaryKey([.init(name: columns.id.name, type: .string)]),
                .unique([
                    .init(name: columns.assetNodeFileId.name, type: .string),
                    .init(name: columns.variantId.name, type: .string),
                ]),
                .unique([.init(name: columns.storageObjectId.name, type: .string)]),
                .foreignKey(
                    columns: [.init(name: columns.assetNodeFileId.name, type: .string)],
                    referencesTable: Asset.File.Table.name,
                    referencedColumns: [.init(name: Asset.File.Table.columns.assetNodeId.name, type: .string)],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
                .foreignKey(
                    columns: [.init(name: columns.variantId.name, type: .string)],
                    referencesTable: Variant.Table.name,
                    referencedColumns: [.init(name: Variant.Table.columns.id.name, type: .string)],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
                .foreignKey(
                    columns: [.init(name: columns.storageObjectId.name, type: .string)],
                    referencesTable: StorageObject.Table.name,
                    referencedColumns: [.init(name: StorageObject.Table.columns.id.name, type: .string)],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
                .foreignKey(
                    columns: [
                        .init(name: columns.variantId.name, type: .string),
                        .init(name: columns.variantProcessorId.name, type: .string),
                    ],
                    referencesTable: Variant.Processor.Table.name,
                    referencedColumns: [
                        .init(name: Variant.Processor.Table.columns.variantId.name, type: .string),
                        .init(name: Variant.Processor.Table.columns.id.name, type: .string),
                    ],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
            ],
            indexes: [
                .init(name: "media_asset_node_file_variant_asset_created_idx", columns: [
                    .init(name: columns.assetNodeFileId.name, type: .string),
                    .init(name: columns.createdAt.name, type: .timestamp),
                    .init(name: columns.id.name, type: .string),
                ]),
                .init(name: "media_asset_node_file_variant_variant_id_idx", columns: [.init(name: columns.variantId.name, type: .string)]),
                .init(name: "media_asset_node_file_variant_processor_id_idx", columns: [.init(name: columns.variantProcessorId.name, type: .string)]),
            ]
        )
    }
}
