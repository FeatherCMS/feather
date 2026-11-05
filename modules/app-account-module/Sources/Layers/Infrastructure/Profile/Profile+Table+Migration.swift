import AccountModule
import FeatherDBAL

extension Profile.Table {
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
                    name: columns.userId.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(name: columns.firstName.name, type: .string),
                .init(name: columns.lastName.name, type: .string),
                .init(name: columns.profileImageAssetId.name, type: .string),
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
                .unique([.init(name: columns.userId.name, type: .string)]),
                .foreignKey(
                    columns: [.init(name: columns.userId.name, type: .string)],
                    referencesTable: "user_identity",
                    referencedColumns: [.init(name: "id", type: .string)],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
                .foreignKey(
                    columns: [
                        .init(
                            name: columns.profileImageAssetId.name,
                            type: .string
                        )
                    ],
                    referencesTable: "media_asset_node_file",
                    referencedColumns: [
                        .init(name: "asset_node_id", type: .string)
                    ],
                    onDelete: .setNull,
                    onUpdate: nil
                ),
            ],
            indexes: [
                .init(
                    name: "account_profile_image_asset_id_idx",
                    columns: [
                        .init(
                            name: columns.profileImageAssetId.name,
                            type: .string
                        )
                    ]
                )
            ]
        )
    }
}
