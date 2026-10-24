import AccountModule
import FeatherDBAL

extension Invitation.Table {
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
                .init(
                    name: columns.email.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.token.name,
                    type: .string,
                    constraints: [.notNull, .unique]
                ),
                .init(
                    name: columns.roleIds.name,
                    type: .string,
                    constraints: [.notNull, .default(.value("[]"))]
                ),
                .init(
                    name: columns.expiresAt.name,
                    type: .timestamp,
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
                    columns: [.init(name: columns.userId.name, type: .string)],
                    referencesTable: "user_identity",
                    referencedColumns: [.init(name: "id", type: .string)],
                    onDelete: .cascade,
                    onUpdate: nil
                )
            ]
        )
    }
}
