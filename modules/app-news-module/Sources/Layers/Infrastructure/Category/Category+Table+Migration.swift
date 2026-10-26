import FeatherDBAL
import NewsModule

extension Category.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(name: columns.id.name, type: .string),
                .init(name: columns.title.name, type: .string, constraints: [.notNull]),
                .init(name: columns.excerpt.name, type: .string, constraints: [.notNull, .default(.value(""))]),
                .init(name: columns.content.name, type: .text, constraints: [.notNull]),
                .init(name: columns.imageAssetId.name, type: .string),
                .init(name: columns.createdAt.name, type: .timestamp, constraints: [.notNull, .default(.currentTimestamp)]),
                .init(name: columns.updatedAt.name, type: .timestamp, constraints: [.notNull, .default(.currentTimestamp)]),
            ],
            constraints: [
                .primaryKey([.init(name: columns.id.name, type: .string)]),
                .foreignKey(
                    columns: [.init(name: columns.imageAssetId.name, type: .string)],
                    referencesTable: "media_asset_node_file",
                    referencedColumns: [.init(name: "asset_node_id", type: .string)],
                    onDelete: .setNull,
                    onUpdate: nil
                ),
            ],
            indexes: [
                .init(name: "news_category_title_idx", columns: [.init(name: columns.title.name, type: .string)]),
                .init(name: "news_category_image_asset_id_idx", columns: [.init(name: columns.imageAssetId.name, type: .string)]),
            ]
        )
    }
}
