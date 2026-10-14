import FeatherInfrastructure

enum VariableTableSchema {

    static let table = DatabaseTableSchema(
        name: VariableTable.name,
        columns: [
            .init(
                field: VariableTable.Fields.id,
                type: .text,
                constraints: [.primaryKey]
            ),
            .init(
                field: VariableTable.Fields.key,
                type: .text,
                constraints: [.notNull, .unique]
            ),
            .init(
                field: VariableTable.Fields.value,
                type: .text,
                constraints: [.notNull]
            ),
            .init(field: VariableTable.Fields.name, type: .text),
            .init(field: VariableTable.Fields.notes, type: .text),
            .init(
                field: VariableTable.Fields.createdAt,
                type: .timestampWithTimeZone,
                constraints: [.notNull, .defaultValue(.currentTimestamp)]
            ),
            .init(
                field: VariableTable.Fields.updatedAt,
                type: .timestampWithTimeZone,
                constraints: [.notNull, .defaultValue(.currentTimestamp)]
            )
        ]
    )
}
