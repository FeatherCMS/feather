import AuthModule
import FeatherDBAL

extension RolePermission.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: Self.name,
            columns: [
                .init(
                    name: columns.roleId.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.permissionId.name,
                    type: .string,
                    constraints: [.notNull]
                ),
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
                .primaryKey([
                    .init(name: columns.roleId.name, type: .string),
                    .init(name: columns.permissionId.name, type: .string),
                ]),
                .foreignKey(
                    columns: [.init(name: columns.roleId.name, type: .string)],
                    referencesTable: "user_role",
                    referencedColumns: [.init(name: "id", type: .string)],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
                .foreignKey(
                    columns: [
                        .init(name: columns.permissionId.name, type: .string)
                    ],
                    referencesTable: "system_permission",
                    referencedColumns: [.init(name: "id", type: .string)],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
            ],
            indexes: [
                .init(
                    name: "auth_role_permission_permission_id_idx",
                    columns: [
                        .init(name: columns.permissionId.name, type: .string)
                    ]
                )
            ]
        )
    }
}
