import FeatherDBAL
import WebDomain
import WebModule

extension Menu.Table {
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
                    name: columns.key.name,
                    type: .string,
                    constraints: [.notNull, .unique]
                ),
                .init(
                    name: columns.name.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(name: columns.notes.name, type: .text),
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
            indexes: [
                .init(
                    name: "web_menu_key_idx",
                    columns: [.init(name: columns.key.name, type: .string)]
                )
            ]
        )
    }
}
