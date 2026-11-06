import FeatherDBAL
import UserModule

extension IdentityRole.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: Self.name,
            columns: [
                .init(
                    name: Self.columns.roleId.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: Self.columns.identityId.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: Self.columns.createdAt.name,
                    type: .timestamp,
                    constraints: [.notNull, .default(.currentTimestamp)]
                ),
                .init(
                    name: Self.columns.updatedAt.name,
                    type: .timestamp,
                    constraints: [.notNull, .default(.currentTimestamp)]
                ),
            ],
            constraints: [
                .primaryKey([
                    .init(name: Self.columns.roleId.name, type: .string),
                    .init(name: Self.columns.identityId.name, type: .string),
                ]),
                .foreignKey(
                    columns: [
                        .init(name: Self.columns.roleId.name, type: .string)
                    ],
                    referencesTable: Role.Table.name,
                    referencedColumns: [
                        .init(name: Role.Table.columns.id.name, type: .string)
                    ],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
                .foreignKey(
                    columns: [
                        .init(name: Self.columns.identityId.name, type: .string)
                    ],
                    referencesTable: Identity.Table.name,
                    referencedColumns: [
                        .init(
                            name: Identity.Table.columns.id.name,
                            type: .string
                        )
                    ],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
            ],
            indexes: [
                .init(
                    name: "user_identity_role_identity_id_idx",
                    columns: [
                        .init(name: Self.columns.identityId.name, type: .string)
                    ]
                )
            ]
        )
    }
}
