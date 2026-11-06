import AuthModule
import FeatherDBAL

extension Session.Table {
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
                    name: columns.token.name,
                    type: .string,
                    constraints: [.notNull, .unique]
                ),
                .init(
                    name: columns.identityId.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.authenticationType.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.authenticationReference.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.isPersistent.name,
                    type: .boolean,
                    constraints: [.notNull, .default(.value(false))]
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
                .init(
                    name: columns.expiresAt.name,
                    type: .timestamp,
                    constraints: [.notNull]
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
                    name: "auth_session_identity_id_idx",
                    columns: [
                        .init(name: columns.identityId.name, type: .string)
                    ]
                )
            ]
        )
    }
}
