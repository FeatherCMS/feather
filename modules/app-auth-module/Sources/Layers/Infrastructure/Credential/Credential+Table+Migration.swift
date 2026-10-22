import AuthModule
import FeatherDBAL

extension Credential.Table {
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
                    name: columns.authEmailId.name,
                    type: .string,
                    constraints: [.notNull, .unique]
                ),
                .init(
                    name: columns.passwordHash.name,
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
                .foreignKey(
                    columns: [
                        .init(name: columns.authEmailId.name, type: .string)
                    ],
                    referencesTable: Email.Table.name,
                    referencedColumns: [
                        .init(
                            name: Email.Table.columns.id.name,
                            type: .string
                        )
                    ],
                    onDelete: .cascade,
                    onUpdate: nil
                )
            ],
            indexes: [
                .init(
                    name: "auth_email_credential_auth_email_id_idx",
                    columns: [
                        .init(name: columns.authEmailId.name, type: .string)
                    ]
                )
            ]
        )
    }
}
