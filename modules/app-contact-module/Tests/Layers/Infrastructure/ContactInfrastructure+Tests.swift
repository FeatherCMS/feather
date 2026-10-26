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
        #expect(schema.columns[1].constraints.contains {
            if case .notNull = $0 { true } else { false }
        })
        #expect(schema.columns[1].constraints.contains {
            if case .unique = $0 { true } else { false }
        })
        for index in [1, 2, 3, 4] {
            #expect(schema.columns[index].constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
        for column in [schema.columns[3], schema.columns[4]] {
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                guard case .string(let actual) = value.storage else { return false }
                return actual.isEmpty
            })
        }
        for column in [schema.columns[6], schema.columns[7]] {
            #expect(column.type == .timestamp)
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                if case .currentTimestamp = value.storage { return true }
                return false
            })
        }
        #expect(schema.indexes.map(\.name) == ["contact_form_key_idx"])
        #expect(schema.indexes[0].columns.map(\.name) == ["key"])
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
        #expect(schema.columns[1].constraints.contains {
            if case .notNull = $0 { true } else { false }
        })
        #expect(schema.columns[1].constraints.contains {
            if case .unique = $0 { true } else { false }
        })
        for index in [1, 2, 3, 4, 5] {
            #expect(schema.columns[index].constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
        #expect(schema.columns[4].constraints.contains {
            guard case .default(let value) = $0 else { return false }
            guard case .string(let actual) = value.storage else { return false }
            return actual == "[]"
        })
        #expect(schema.columns[5].constraints.contains {
            guard case .default(let value) = $0 else { return false }
            guard case .boolean(let actual) = value.storage else { return false }
            return !actual
        })
        for column in [schema.columns[6], schema.columns[7]] {
            #expect(column.type == .timestamp)
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                if case .currentTimestamp = value.storage { return true }
                return false
            })
        }
        #expect(schema.indexes.map(\.name) == ["contact_form_field_key_idx"])
        #expect(schema.indexes[0].columns.map(\.name) == ["key"])
    }

    @Test
    func submissionSchemaDefinesFormRelationAndIndexes() {
        let schema = Submission.Table.tableCreationSchema

        #expect(schema.name == "contact_form_submission")
        #expect(
            schema.columns.map(\.name) == [
                "id", "form_id", "values", "items_snapshot", "metadata",
                "status", "created_at", "updated_at",
            ]
        )
        #expect(schema.constraints.contains {
            guard case .primaryKey(let columns) = $0 else { return false }
            return columns.map(\.name) == ["id"]
        })
        for index in [1, 2, 3, 5] {
            #expect(schema.columns[index].constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
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
        #expect(schema.columns[5].constraints.contains {
            guard case .default(let value) = $0 else { return false }
            guard case .string(let actual) = value.storage else { return false }
            return actual == "received"
        })
        for column in [schema.columns[6], schema.columns[7]] {
            #expect(column.type == .timestamp)
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                if case .currentTimestamp = value.storage { return true }
                return false
            })
        }
        #expect(
            schema.indexes.map(\.name) == [
                "contact_form_submission_form_id_idx",
                "contact_form_submission_status_idx",
            ]
        )
        #expect(
            schema.indexes.map { $0.columns.map(\.name) } == [
                ["form_id", "created_at"], ["status"],
            ]
        )
    }

    @Test
    func submissionMailSchemaDefinesFormRelationAndIndex() {
        let schema = SubmissionMail.Table.tableCreationSchema

        #expect(schema.name == "contact_form_mail")
        #expect(
            schema.columns.map(\.name) == [
                "id", "form_id", "mail_from", "mail_to", "subject",
                "additional_headers", "message_body", "created_at", "updated_at",
            ]
        )
        #expect(schema.constraints.contains {
            guard case .primaryKey(let columns) = $0 else { return false }
            return columns.map(\.name) == ["id"]
        })
        for index in [1, 2, 3, 4, 5, 6] {
            #expect(schema.columns[index].constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
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
        #expect(schema.columns[5].constraints.contains {
            guard case .default(let value) = $0 else { return false }
            guard case .string(let actual) = value.storage else { return false }
            return actual.isEmpty
        })
        for column in [schema.columns[7], schema.columns[8]] {
            #expect(column.type == .timestamp)
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                if case .currentTimestamp = value.storage { return true }
                return false
            })
        }
        #expect(
            schema.indexes.map(\.name) == ["contact_form_mail_form_id_idx"]
        )
        #expect(
            schema.indexes[0].columns.map(\.name) == ["form_id", "id"]
        )
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
        #expect(schema.columns[0].constraints.contains {
            if case .notNull = $0 { true } else { false }
        })
        #expect(schema.columns[1].constraints.contains {
            if case .notNull = $0 { true } else { false }
        })
        #expect(schema.columns[2].constraints.contains {
            guard case .notNull = $0 else { return false }
            return true
        })
        #expect(schema.columns[2].constraints.contains {
            guard case .default(let value) = $0 else { return false }
            guard case .integer(let actual) = value.storage else { return false }
            return actual == 0
        })
        #expect(schema.constraints.contains {
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
                && table == Form.Table.name
                && referenced.map(\.name) == ["id"]
        })
        #expect(schema.constraints.contains {
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
            return columns.map(\.name) == ["field_id"]
                && table == FormField.Table.name
                && referenced.map(\.name) == ["id"]
        })
        #expect(
            schema.indexes.map(\.columns).map { $0.map(\.name) } == [
                ["form_id", "position"],
                ["field_id"],
            ]
        )
    }
}
