import FeatherDBAL
import Testing

@testable import ContactInfrastructure

@Suite
struct ContactInfrastructureTestSuite {

    @Test
    func formFieldAssignmentSchemaDefinesKeysAndIndexes() {
        let schema = FormFormFieldTableSchema.table

        #expect(schema.name == "contact_form_form_field")
        #expect(
            schema.columns.map(\.name) == ["form_id", "field_id", "position"]
        )
        #expect(
            schema.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["form_id", "field_id"]
            }
        )
        #expect(
            schema.constraints
                .filter {
                    if case .foreignKey = $0 { return true }
                    return false
                }
                .count == 2
        )
        #expect(
            schema.indexes.map(\.columns).map { $0.map(\.name) } == [
                ["form_id", "position"],
                ["field_id"],
            ]
        )
    }
}
