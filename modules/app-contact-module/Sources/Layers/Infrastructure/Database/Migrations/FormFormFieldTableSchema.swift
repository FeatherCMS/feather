import FeatherInfrastructure
import FeatherDBAL

enum FormFormFieldTableSchema {

    private enum Columns {
        static let formID = DatabaseTableColumnSchema(
            name: "form_id",
            type: .string,
            constraints: [.notNull]
        )
        static let fieldID = DatabaseTableColumnSchema(
            name: "field_id",
            type: .string,
            constraints: [.notNull]
        )
        static let position = DatabaseTableColumnSchema(
            name: "position",
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
                referencesTable: FormTable.name,
                referencedColumns: [FormTable.Fields.id],
                onDelete: .cascade,
                onUpdate: nil
            ),
            .foreignKey(
                columns: [Columns.fieldID],
                referencesTable: FormFieldTable.name,
                referencedColumns: [FormFieldTable.Fields.id],
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
