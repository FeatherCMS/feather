import ContactModule
import FeatherDBAL

extension FormField.Table {
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
                    name: columns.type.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.label.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.allowedValues.name,
                    type: .json,
                    constraints: [.notNull, .default(.value("[]"))]
                ),
                .init(
                    name: columns.isRequired.name,
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
            ],
            constraints: [
                .primaryKey([.init(name: columns.id.name, type: .string)])
            ],
            indexes: [
                .init(
                    name: "contact_form_field_key_idx",
                    columns: [.init(name: columns.key.name, type: .string)]
                )
            ]
        )
    }
}
