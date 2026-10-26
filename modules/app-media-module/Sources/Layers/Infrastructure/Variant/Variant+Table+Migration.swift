import FeatherDBAL
import MediaModule

extension Variant.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(name: columns.id.name, type: .string),
                .init(
                    name: columns.key.name,
                    type: .string,
                    constraints: [.notNull, .unique]
                ),
                .init(
                    name: columns.name.name,
                    type: .string,
                    constraints: [.notNull, .unique]
                ),
                .init(
                    name: columns.isRequired.name,
                    type: .boolean,
                    constraints: [.notNull, .default(.value(true))]
                ),
                .init(
                    name: columns.isActive.name,
                    type: .boolean,
                    constraints: [.notNull, .default(.value(true))]
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
                .primaryKey([.init(name: columns.id.name, type: .string)])
            ],
            indexes: []
        )
    }
}
