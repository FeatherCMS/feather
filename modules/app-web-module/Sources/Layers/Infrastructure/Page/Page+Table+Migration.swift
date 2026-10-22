import FeatherDBAL
import WebDomain
import WebModule

extension Page.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: Self.name,
            columns: [
                .init(
                    name: columns.id.name,
                    type: .string,
                    constraints: [.primaryKey]
                ),
                .init(
                    name: columns.title.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.excerpt.name,
                    type: .text,
                    constraints: [.notNull, .default(.value(""))]
                ),
                .init(
                    name: columns.content.name,
                    type: .text,
                    constraints: [.notNull]
                ),
                .init(name: columns.imageAssetId.name, type: .string),
                .init(
                    name: columns.createdAt.name,
                    type: .timestamp,
                    constraints: [.notNull, .default(.currentTimestamp)]
                ),
                .init(
                    name: columns.updatedAt.name,
                    type: .timestamp,
                    constraints: [.notNull, .default(.currentTimestamp)]
                ),
            ],
            constraints: [
                .foreignKey(
                    columns: [
                        .init(name: columns.imageAssetId.name, type: .string)
                    ],
                    referencesTable: "media_asset_node_file",
                    referencedColumns: [
                        .init(name: "asset_node_id", type: .string)
                    ],
                    onDelete: .setNull,
                    onUpdate: nil
                )
            ],
            indexes: [
                .init(
                    name: "web_page_title_idx",
                    columns: [.init(name: columns.title.name, type: .string)]
                ),
                .init(
                    name: "web_page_image_asset_id_idx",
                    columns: [
                        .init(name: columns.imageAssetId.name, type: .string)
                    ]
                ),
            ]
        )
    }
}
