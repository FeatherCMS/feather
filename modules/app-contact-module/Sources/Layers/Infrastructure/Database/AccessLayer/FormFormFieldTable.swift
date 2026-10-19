import FeatherDatabase

struct FormFormFieldTable {
    static let name = "contact_form_form_field"

    enum Fields {
        static let formID = "form_id"
        static let fieldID = "field_id"
        static let position = "position"
    }

    let connection: any DatabaseConnection

    func assign(
        formId: String,
        fieldId: String,
        position: Int
    ) async throws {
        try await connection.run(
            query: #"""
                INSERT INTO \#(unescaped: Self.name) (
                    \#(unescaped: Fields.formID),
                    \#(unescaped: Fields.fieldID),
                    \#(unescaped: Fields.position)
                )
                VALUES (\#(formId), \#(fieldId), \#(position))
                ON CONFLICT (
                    \#(unescaped: Fields.formID),
                    \#(unescaped: Fields.fieldID)
                ) DO UPDATE SET
                    \#(unescaped: Fields.position) = EXCLUDED.\#(unescaped: Fields.position);
                """#
        ) { _ in }
    }

    func unassign(
        formId: String,
        fieldId: String
    ) async throws {
        try await connection.run(
            query: #"""
                DELETE FROM \#(unescaped: Self.name)
                WHERE \#(unescaped: Fields.formID) = \#(formId)
                    AND \#(unescaped: Fields.fieldID) = \#(fieldId);
                """#
        ) { _ in }
    }
}
