import ContactDomain
import ContactModule
import FeatherDBAL
import FeatherDatabase
import FeatherInfrastructure
import Foundation

extension FormField {
    struct AccessLayer {
        static func jsonString(
            _ values: [Model.Option]
        ) throws -> String {
            let data = try JSONEncoder().encode(values)
            guard let result = String(data: data, encoding: .utf8) else {
                throw RepositoryError(
                    reason: .database(.rowDecoding),
                    logMessage: "Unable to encode contact form field options",
                    userFriendlyMessage:
                        "Unable to encode contact form field options."
                )
            }
            return result
        }

        struct Row {
            let id: String
            let formId: String
            let key: String
            let type: String
            let label: String
            let allowedValuesJSON: String
            let isRequired: Bool
            let position: Int
            let createdAt: Date
            let updatedAt: Date

            init(from row: any DatabaseRow) throws {
                id = try row.decode(column: "id", as: String.self)
                formId = try row.decode(column: "form_id", as: String.self)
                key = try row.decode(column: "key", as: String.self)
                type = try row.decode(column: "type", as: String.self)
                label = try row.decode(column: "label", as: String.self)
                allowedValuesJSON = try row.decode(
                    column: "allowed_values",
                    as: String.self
                )
                isRequired = try row.decode(
                    column: "is_required",
                    as: Bool.self
                )
                position = try row.decode(column: "position", as: Int.self)
                createdAt = try row.decode(column: "created_at", as: Date.self)
                updatedAt = try row.decode(column: "updated_at", as: Date.self)
            }

            func allowedValues() throws -> [Model.Option] {
                try JSONDecoder()
                    .decode(
                        [Model.Option].self,
                        from: Data(allowedValuesJSON.utf8)
                    )
            }
        }

        let connection: any DatabaseConnection

        static func applyCheckConstraints(on connection: any DatabaseConnection)
            async throws
        {
            let queries: [DatabaseQuery] = [
                #"""
                DO $$ BEGIN
                    IF NOT EXISTS (
                        SELECT 1 FROM pg_constraint
                        WHERE conname = 'contact_form_field_type_check'
                    ) THEN
                        ALTER TABLE contact_form_field
                        ADD CONSTRAINT contact_form_field_type_check
                        CHECK (type IN ('text', 'textarea', 'select', 'radio', 'toggle', 'hidden'));
                    END IF;
                END $$;
                """#,
                #"""
                DO $$ BEGIN
                    IF NOT EXISTS (
                        SELECT 1 FROM pg_constraint
                        WHERE conname IN (
                            'contact_form_field_check',
                            'contact_form_field_allowed_values_check'
                        )
                    ) THEN
                        ALTER TABLE contact_form_field
                        ADD CONSTRAINT contact_form_field_allowed_values_check
                        CHECK (
                            (type IN ('select', 'radio') AND jsonb_array_length(allowed_values) > 0)
                            OR (type IN ('text', 'textarea', 'toggle', 'hidden') AND allowed_values = '[]'::jsonb)
                        );
                    END IF;
                END $$;
                """#,
            ]

            for query in queries {
                try await connection.run(query: query) { _ in }
            }
        }

        func find(id: String, formId: String) async throws -> Row? {
            try await connection.run(
                query: #"""
                    SELECT field.*, assignment.form_id, assignment.position
                    FROM contact_form_field AS field
                    JOIN contact_form_form_field AS assignment ON assignment.field_id = field.id
                    WHERE field.id = \#(id) AND assignment.form_id = \#(formId)
                    LIMIT 1;
                    """#
            ) { sequence in
                try await sequence.collect().first.map { try Row(from: $0) }
            }
        }

        func list(formId: String) async throws -> [Row] {
            try await connection.run(
                query: #"""
                    SELECT field.*, assignment.form_id, assignment.position
                    FROM contact_form_field AS field
                    JOIN contact_form_form_field AS assignment ON assignment.field_id = field.id
                    WHERE assignment.form_id = \#(formId)
                    ORDER BY assignment.position, field.id;
                    """#
            ) { sequence in
                try await sequence.collect().map { try Row(from: $0) }
            }
        }

        func listUnassigned() async throws -> [Row] {
            try await connection.run(
                query: #"""
                    SELECT field.*, '' AS form_id, 0 AS position
                    FROM contact_form_field AS field
                    WHERE NOT EXISTS (
                        SELECT 1 FROM contact_form_form_field AS assignment
                        WHERE assignment.field_id = field.id
                    )
                    ORDER BY field.id;
                    """#
            ) { sequence in
                try await sequence.collect().map { try Row(from: $0) }
            }
        }

        func delete(ids: [String], formId: String) async throws -> [String] {
            guard !ids.isEmpty else { return [] }
            return try await connection.run(
                query: #"""
                    DELETE FROM contact_form_field
                    WHERE id IN (\#(ids))
                      AND EXISTS (
                          SELECT 1 FROM contact_form_form_field
                          WHERE form_id = \#(formId) AND field_id = contact_form_field.id
                      )
                    RETURNING id;
                    """#
            ) { sequence in
                try await sequence.collect()
                    .map { try $0.decode(column: "id", as: String.self) }
            }
        }
    }
}
