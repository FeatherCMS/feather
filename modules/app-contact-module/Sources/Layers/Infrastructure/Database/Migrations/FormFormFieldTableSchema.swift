import FeatherInfrastructure

enum FormFormFieldTableSchema {

    static let table = DatabaseTableSchema(
        name: FormFormFieldTable.name,
        columns: [
            .init(
                field: FormFormFieldTable.Fields.formID,
                type: .text,
                constraints: [.notNull]
            ),
            .init(
                field: FormFormFieldTable.Fields.fieldID,
                type: .text,
                constraints: [.notNull]
            ),
            .init(
                field: FormFormFieldTable.Fields.position,
                type: .integer,
                constraints: [.notNull, .defaultValue(.integer(0))]
            )
        ],
        constraints: [
            .primaryKey([
                FormFormFieldTable.Fields.formID,
                FormFormFieldTable.Fields.fieldID
            ]),
            .foreignKey(
                columns: [FormFormFieldTable.Fields.formID],
                referencesTable: FormTable.name,
                referencedColumns: [FormTable.Fields.id],
                onDelete: .cascade,
                onUpdate: nil
            ),
            .foreignKey(
                columns: [FormFormFieldTable.Fields.fieldID],
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
                    FormFormFieldTable.Fields.formID,
                    FormFormFieldTable.Fields.position
                ]
            ),
            .init(
                name: "contact_form_form_field_field_id_idx",
                columns: [FormFormFieldTable.Fields.fieldID]
            )
        ]
    )
}
