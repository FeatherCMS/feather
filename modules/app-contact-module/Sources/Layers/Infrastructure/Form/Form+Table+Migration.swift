import ContactModule
import FeatherDBAL

extension Form.Table {
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
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.successMessage.name,
                    type: .text,
                    constraints: [.notNull, .default(.value(""))]
                ),
                .init(
                    name: columns.failureMessage.name,
                    type: .text,
                    constraints: [.notNull, .default(.value(""))]
                ),
                .init(
                    name: columns.submitLabel.name,
                    type: .string,
                    constraints: [.notNull, .default(.value("Submit"))]
                ),
                .init(name: columns.redirectUrl.name, type: .string),
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
                    name: "contact_form_key_idx",
                    columns: [.init(name: columns.key.name, type: .string)]
                )
            ]
        )
    }
}
