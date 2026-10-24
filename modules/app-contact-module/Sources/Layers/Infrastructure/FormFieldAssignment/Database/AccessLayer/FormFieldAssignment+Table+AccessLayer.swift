import ContactModule
import FeatherDBAL
import FeatherDatabase
import FeatherInfrastructure

extension FormFieldAssignment.Table {
    func assign(
        formId: String,
        fieldId: String,
        position: Int
    ) async throws {
        try await connection.run(
            query: #"""
                INSERT INTO \#(unescaped: Self.name) (
                    \#(unescaped: Self.columns.formId.name),
                    \#(unescaped: Self.columns.fieldId.name),
                    \#(unescaped: Self.columns.position.name)
                )
                VALUES (\#(formId), \#(fieldId), \#(position))
                ON CONFLICT (
                    \#(unescaped: Self.columns.formId.name),
                    \#(unescaped: Self.columns.fieldId.name)
                ) DO UPDATE SET
                    \#(unescaped: Self.columns.position.name) = EXCLUDED.\#(unescaped: Self.columns.position.name);
                """#
        ) { _ in }
    }

    func unassign(
        formId: String,
        fieldId: String
    ) async throws {
        try await DatabaseAccessLayer<Self>(context: context)
            .delete(
                where: DatabaseQueryFilter<Self>()
                    .where(\.formId, equals: formId)
                    .where(\.fieldId, equals: fieldId)
            )
    }
}
