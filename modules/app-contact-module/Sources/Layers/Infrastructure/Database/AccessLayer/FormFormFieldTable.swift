import FeatherDBAL
import FeatherDatabase
import FeatherInfrastructure

struct FormFormFieldTable: DatabaseTable, DatabaseTableWithDelete {
    static let name = "contact_form_form_field"
    static let columns = Columns()

    struct Columns: DatabaseTableColumns {
        let formId = DatabaseTableColumn<String>(name: "form_id")
        let fieldId = DatabaseTableColumn<String>(name: "field_id")
        let position = DatabaseTableColumn<Int>(name: "position")
    }

    enum Fields {
        static let formID = "form_id"
        static let fieldID = "field_id"
        static let position = "position"
    }

    let connection: any DatabaseConnection
    let context: DatabaseTransactionContext

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
        try await DatabaseAccessLayer<Self>(context: context).delete(
            where: DatabaseQueryFilter<Self>()
                .where(\.formId, equals: formId)
                .where(\.fieldId, equals: fieldId)
        )
    }
}
