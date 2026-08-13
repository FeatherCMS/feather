import FeatherDatabase

struct FormFormFieldTable {
    let connection: any DatabaseConnection

    func assign(
        formId: String,
        fieldId: String,
        position: Int
    ) async throws {
        try await connection.run(
            query: #"""
                INSERT INTO contact_form_form_field (form_id, field_id, position)
                VALUES (\#(formId), \#(fieldId), \#(position))
                ON CONFLICT (form_id, field_id) DO UPDATE SET position = EXCLUDED.position;
                """#
        ) { _ in }
    }

    func unassign(
        formId: String,
        fieldId: String
    ) async throws {
        try await connection.run(
            query: #"""
                DELETE FROM contact_form_form_field
                WHERE form_id = \#(formId) AND field_id = \#(fieldId);
                """#
        ) { _ in }
    }
}
