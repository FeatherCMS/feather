import ContactModule
import FeatherDBAL
import FeatherInfrastructure

extension FormFieldAssignment.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        let formID = DatabaseTableColumnSchema(
            name: columns.formId.name,
            type: .string,
            constraints: [.notNull]
        )
        let fieldID = DatabaseTableColumnSchema(
            name: columns.fieldId.name,
            type: .string,
            constraints: [.notNull]
        )
        let position = DatabaseTableColumnSchema(
            name: columns.position.name,
            type: .int32,
            constraints: [.notNull, .default(.value(0))]
        )

        return .init(
            name: name,
            columns: [formID, fieldID, position],
            constraints: [
                .primaryKey([formID, fieldID]),
                .foreignKey(
                    columns: [formID],
                    referencesTable: Form.Table.name,
                    referencedColumns: [
                        .init(name: Form.Table.columns.id.name, type: .string)
                    ],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
                .foreignKey(
                    columns: [fieldID],
                    referencesTable: FormField.Table.name,
                    referencedColumns: [
                        .init(
                            name: FormField.Table.columns.id.name,
                            type: .string
                        )
                    ],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
            ],
            indexes: [
                .init(
                    name: "contact_form_form_field_form_id_idx",
                    columns: [formID, position]
                ),
                .init(
                    name: "contact_form_form_field_field_id_idx",
                    columns: [fieldID]
                ),
            ]
        )
    }
}
