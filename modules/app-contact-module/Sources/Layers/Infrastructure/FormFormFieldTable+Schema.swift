import FeatherInfrastructure
import FeatherDBAL
import ContactModule

enum FormFormFieldTableSchema {

    private enum Columns {
        static let formID = DatabaseTableColumnSchema(
            name: FormFormFieldTable.columns.formId.name,
            type: .string,
            constraints: [.notNull]
        )
        static let fieldID = DatabaseTableColumnSchema(
            name: FormFormFieldTable.columns.fieldId.name,
            type: .string,
            constraints: [.notNull]
        )
        static let position = DatabaseTableColumnSchema(
            name: FormFormFieldTable.columns.position.name,
            type: .integer,
            constraints: [.notNull, .default(.value(0))]
        )
    }

    static let table = DatabaseTableSchema(
        name: FormFormFieldTable.name,
        columns: [
            Columns.formID,
            Columns.fieldID,
            Columns.position
        ],
        constraints: [
            .primaryKey([
                Columns.formID,
                Columns.fieldID
            ]),
            .foreignKey(
                columns: [Columns.formID],
                referencesTable: Form.Table.name,
                referencedColumns: [.init(name: Form.Table.columns.id.name, type: .string)],
                onDelete: .cascade,
                onUpdate: nil
            ),
            .foreignKey(
                columns: [Columns.fieldID],
                referencesTable: FormField.Table.name,
                referencedColumns: [.init(name: FormField.Table.columns.id.name, type: .string)],
                onDelete: .cascade,
                onUpdate: nil
            )
        ],
        indexes: [
            .init(
                name: "contact_form_form_field_form_id_idx",
                columns: [
                    Columns.formID,
                    Columns.position
                ]
            ),
            .init(
                name: "contact_form_form_field_field_id_idx",
                columns: [Columns.fieldID]
            )
        ]
    )
}
