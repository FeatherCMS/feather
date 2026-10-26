import FeatherDBAL
import MediaModule

extension Asset.Node.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(name: columns.id.name, type: .string),
                .init(name: columns.parentId.name, type: .string),
                .init(name: columns.name.name, type: .string, constraints: [.notNull]),
                .init(name: columns.slug.name, type: .string, constraints: [.notNull]),
                .init(name: columns.absoluteSlug.name, type: .string, constraints: [.notNull, .default(.value(""))]),
                .init(name: columns.createdAt.name, type: .timestamp, constraints: [.notNull, .default(.currentTimestamp)]),
                .init(name: columns.updatedAt.name, type: .timestamp, constraints: [.notNull, .default(.currentTimestamp)]),
                .init(name: columns.deletedAt.name, type: .timestamp),
            ],
            constraints: [
                .primaryKey([.init(name: columns.id.name, type: .string)]),
                .foreignKey(
                    columns: [.init(name: columns.parentId.name, type: .string)],
                    referencesTable: name,
                    referencedColumns: [.init(name: columns.id.name, type: .string)],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
            ],
            indexes: [
                .init(name: "media_asset_node_parent_id_idx", columns: [.init(name: columns.parentId.name, type: .string)])
            ]
        )
    }
}
