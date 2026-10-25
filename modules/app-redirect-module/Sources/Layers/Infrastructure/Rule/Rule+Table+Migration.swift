import FeatherDBAL
import RedirectModule

extension Rule.Table {
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
                    name: columns.source.name,
                    type: .string,
                    constraints: [.notNull, .unique]
                ),
                .init(
                    name: columns.destination.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.statusCode.name,
                    type: .int32,
                    constraints: [.notNull]
                ),
                .init(name: columns.notes.name, type: .string),
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
            ]
        )
    }
}
