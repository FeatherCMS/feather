import FeatherDBAL
import UserModule

extension Identity.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: Self.name,
            columns: [
                .init(
                    name: Self.columns.id.name,
                    type: .string,
                    constraints: [.primaryKey]
                ),
                .init(
                    name: Self.columns.name.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: Self.columns.status.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: Self.columns.isRoot.name,
                    type: .boolean,
                    constraints: [.notNull, .default(.value(false))]
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
            ]
        )
    }
}
