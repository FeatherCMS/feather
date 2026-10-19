import SystemModule
import FeatherDBAL

extension Variable.Table {

    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: Self.name,
            columns: [
                .init(
                    name: Self.columns.id.name,
                    type: .string
                ),
                .init(
                    name: Self.columns.key.name,
                    type: .string,
                    constraints: [.notNull, .unique]
                ),
                .init(
                    name: Self.columns.value.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: Self.columns.name.name,
                    type: .string
                ),
                .init(
                    name: Self.columns.notes.name,
                    type: .string
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
                    .init(name: Self.columns.id.name, type: .string)
                ])
            ]
        )
    }
}
