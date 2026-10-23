import FeatherDBAL
import MediaModule

extension Asset.Folder.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(name: columns.assetNodeId.name, type: .string),
                .init(name: columns.assetCount.name, type: .integer, constraints: [.notNull, .default(.value(0))]),
                .init(name: columns.totalSizeBytes.name, type: .integer, constraints: [.notNull, .default(.value(0))]),
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
            ]
        )
    }
}
