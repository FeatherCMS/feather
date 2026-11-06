import AccountModule
import FeatherDBAL

extension Settings.Table {
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
                    name: columns.language.name,
                    type: .string,
                    constraints: [.notNull, .default(.value("en"))]
                ),
                .init(
                    name: columns.timezone.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.pageSize.name,
                    type: .int32,
                    constraints: [.notNull, .default(.value(20))]
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
                .unique([.init(name: columns.userId.name, type: .string)]),
                .foreignKey(
                    columns: [.init(name: columns.userId.name, type: .string)],
                    referencesTable: "user_identity",
                    referencedColumns: [.init(name: "id", type: .string)],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
            ]
        )
    }
}
