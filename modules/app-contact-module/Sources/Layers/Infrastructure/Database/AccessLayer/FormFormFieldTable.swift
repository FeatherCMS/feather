import FeatherDatabase
import FeatherInfrastructure

struct FormFormFieldTable: DatabaseTable {
    static let name = "contact_form_form_field"

    enum Fields {
        static let formID = DatabaseField<String>("form_id")
        static let fieldID = DatabaseField<String>("field_id")
        static let position = DatabaseField<Int>("position")
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
                    \#(unescaped: Fields.formID.name),
                    \#(unescaped: Fields.fieldID.name),
                    \#(unescaped: Fields.position.name)
                )
                VALUES (\#(formId), \#(fieldId), \#(position))
                ON CONFLICT (
                    \#(unescaped: Fields.formID.name),
                    \#(unescaped: Fields.fieldID.name)
                ) DO UPDATE SET
                    \#(unescaped: Fields.position.name) = EXCLUDED.\#(unescaped: Fields.position.name);
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
                WHERE \#(unescaped: Fields.formID.name) = \#(formId)
                    AND \#(unescaped: Fields.fieldID.name) = \#(fieldId);
                """#
        ) { _ in }
    }
}
