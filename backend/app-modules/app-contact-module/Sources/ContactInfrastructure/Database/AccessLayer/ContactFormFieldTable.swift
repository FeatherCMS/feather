import ContactDomain
import FeatherDatabase
import Infrastructure
import class Foundation.JSONDecoder
import class Foundation.JSONEncoder
import struct Foundation.Data
import struct Foundation.Date

extension ContactFormFieldTable.Row {

    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.formId = try row.decode(column: "form_id", as: String.self)
        self.key = try row.decode(column: "key", as: String.self)
        self.type = try row.decode(column: "type", as: String.self)
        self.label = try row.decode(column: "label", as: String.self)
        self.allowedValuesJSON = try row.decode(
            column: "allowed_values",
            as: String.self
        )
        self.isRequired = try row.decode(column: "is_required", as: Bool.self)
        self.position = try row.decode(column: "position", as: Int.self)
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct ContactFormFieldTable {

    struct Row {

        struct Create {
            let id: String
            let formId: String
            let key: String
            let type: String
            let label: String
            let allowedValuesJSON: String
            let isRequired: Bool
            let position: Int
        }

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
    }

    let connection: any DatabaseConnection

    func create(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO contact_form_field (
                    id, key, type, label, allowed_values,
                    is_required, created_at, updated_at
                )
                VALUES (
                    \#(row.id), \#(row.key), \#(row.type),
                    \#(row.label), \#(row.allowedValuesJSON)::jsonb,
                    \#(row.isRequired), NOW(), NOW()
                )
                RETURNING *, '__global_contact_fields__' AS form_id, 0 AS position;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func find(
        id: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *, '__global_contact_fields__' AS form_id, 0 AS position
                FROM contact_form_field
                WHERE id = \#(id)
                LIMIT 1;
                """#
        ) { sequence in
            try await sequence.collect().first.map { try Row(from: $0) }
        }
    }

    func list(
        formId: String
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT i.*, \#(formId) AS form_id, COALESCE(a.position, 0) AS position
                FROM contact_form_field i
                LEFT JOIN contact_form_form_field a
                    ON a.field_id = i.id AND a.form_id = \#(formId)
                WHERE (\#(formId) = '__global_contact_fields__')
                   OR (\#(formId) <> '__global_contact_fields__' AND a.field_id IS NOT NULL)
                ORDER BY COALESCE(a.position, 0), i.id;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func update(
        id: String,
        row: Row
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                UPDATE contact_form_field
                SET key = \#(row.key),
                    type = \#(row.type),
                    label = \#(row.label),
                    allowed_values = \#(row.allowedValuesJSON)::jsonb,
                    is_required = \#(row.isRequired),
                    updated_at = NOW()
                WHERE id = \#(id)
                RETURNING *, '__global_contact_fields__' AS form_id, 0 AS position;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func delete(
        id: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                DELETE FROM contact_form_field
                WHERE id = \#(id)
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}

extension ContactFormFieldTable.Row {
    func allowedValues() throws -> [ContactFormItem.Option] {
        try JSONDecoder().decode(
            [ContactFormItem.Option].self,
            from: Data(allowedValuesJSON.utf8)
        )
    }
}

extension ContactFormItem.Option {
    static func jsonString(
        _ values: [Self]
    ) throws -> String {
        let data = try JSONEncoder().encode(values)
        guard let result = String(data: data, encoding: .utf8) else {
            throw RepositoryError(
                reason: .database(.rowDecoding),
                logMessage: "Unable to encode contact form item options",
                userFriendlyMessage: "Unable to encode contact form item options."
            )
        }
        return result
    }
}
