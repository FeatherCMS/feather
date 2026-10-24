import ContactModule
import FeatherDBAL
import Testing

@testable import ContactInfrastructure

@Suite
struct ContactInfrastructureTests {
    @Test
    func formSchemaDefinesColumnsPrimaryKeyAndUniqueKeyIndex() {
        let schema = Form.Table.tableCreationSchema

        #expect(schema.name == "contact_form")
        #expect(
            schema.columns.map(\.name) == [
                "id", "key", "name", "success_message", "failure_message",
                "redirect_url", "created_at", "updated_at",
            ]
        )
        #expect(
            schema.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["id"]
            }
        )
        #expect(schema.indexes.map(\.name) == ["contact_form_key_idx"])
    }

    @Test
    func formFieldSchemaDefinesColumnsPrimaryKeyAndIndex() {
        let schema = FormField.Table.tableCreationSchema

        #expect(schema.name == "contact_form_field")
        #expect(
            schema.columns.map(\.name) == [
                "id", "key", "type", "label", "allowed_values", "is_required",
                "created_at", "updated_at",
            ]
        )
        #expect(
            schema.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["id"]
            }
        )
        #expect(schema.indexes.map(\.name) == ["contact_form_field_key_idx"])
    }

    @Test
    func submissionSchemaDefinesFormRelationAndIndexes() {
        let schema = Submission.Table.tableCreationSchema

        #expect(schema.name == "contact_form_submission")
        #expect(
            schema.constraints.contains {
                guard
                    case .foreignKey(
                        let columns,
                        let table,
                        let referenced,
                        let onDelete,
                        _
                    ) = $0
                else { return false }
                guard case .cascade? = onDelete else { return false }
                return columns.map(\.name) == ["form_id"]
                    && table == "contact_form"
                    && referenced.map(\.name) == ["id"]
            }
        )
        #expect(
            schema.indexes.map(\.name) == [
                "contact_form_submission_form_id_idx",
                "contact_form_submission_status_idx",
            ]
        )
    }

    @Test
    func submissionMailSchemaDefinesFormRelationAndIndex() {
        let schema = SubmissionMail.Table.tableCreationSchema

        #expect(schema.name == "contact_form_mail")
        #expect(
            schema.constraints.contains {
                guard
                    case .foreignKey(
                        let columns,
                        let table,
                        let referenced,
                        let onDelete,
                        _
                    ) = $0
                else { return false }
                guard case .cascade? = onDelete else { return false }
                return columns.map(\.name) == ["form_id"]
                    && table == "contact_form"
                    && referenced.map(\.name) == ["id"]
            }
        )
        #expect(schema.indexes.map(\.name) == ["contact_form_mail_form_id_idx"])
    }

    @Test
    func formFieldAssignmentSchemaDefinesKeysAndIndexes() {
        let schema = FormFieldAssignment.Table.tableCreationSchema

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
