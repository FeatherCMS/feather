import FeatherDBAL
import MediaModule

extension Asset.File.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(name: columns.assetNodeId.name, type: .string),
                .init(name: columns.storageObjectId.name, type: .string, constraints: [.notNull, .unique]),
                .init(name: columns.status.name, type: .string, constraints: [.notNull]),
                .init(name: columns.title.name, type: .string),
                .init(name: columns.altText.name, type: .string),
            ],
            constraints: [
                .primaryKey([.init(name: columns.assetNodeId.name, type: .string)]),
                .foreignKey(
                    columns: [.init(name: columns.assetNodeId.name, type: .string)],
                    referencesTable: Asset.Node.Table.name,
                    referencedColumns: [.init(name: Asset.Node.Table.columns.id.name, type: .string)],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
                .foreignKey(
                    columns: [.init(name: columns.storageObjectId.name, type: .string)],
                    referencesTable: StorageObject.Table.name,
                    referencedColumns: [.init(name: StorageObject.Table.columns.id.name, type: .string)],
                    onDelete: nil,
                    onUpdate: nil
                ),
            ],
            indexes: [
                .init(name: "media_asset_node_file_status_idx", columns: [.init(name: columns.status.name, type: .string)])
            ]
        )
    }
}
