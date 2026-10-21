import AuthModule
import FeatherDBAL

extension AuthEmail.Table {
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
                    name: columns.identityId.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.email.name,
                    type: .string,
                    constraints: [.notNull, .unique]
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
                .foreignKey(
                    columns: [
                        .init(name: columns.identityId.name, type: .string)
                    ],
                    referencesTable: "user_identity",
                    referencedColumns: [.init(name: "id", type: .string)],
                    onDelete: .cascade,
                    onUpdate: nil
                )
            ],
            indexes: [
                .init(
                    name: "auth_email_identity_id_idx",
                    columns: [
                        .init(name: columns.identityId.name, type: .string)
                    ]
                )
            ]
        )
    }
}
