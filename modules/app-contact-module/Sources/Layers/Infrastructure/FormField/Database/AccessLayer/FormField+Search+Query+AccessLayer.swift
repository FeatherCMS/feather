import ContactApplication
import ContactModule
import FeatherApplication
import FeatherDatabase

extension FormField.Search.Query {
    struct AccessLayer: Sendable {
        struct Item: Sendable {
            let id: String
            let key: String
            let type: String
            let label: String
            let isRequired: Bool

            init(from row: any DatabaseRow) throws {
                id = try row.decode(column: "id", as: String.self)
                key = try row.decode(column: "key", as: String.self)
                type = try row.decode(column: "type", as: String.self)
                label = try row.decode(column: "label", as: String.self)
                isRequired = try row.decode(
                    column: "is_required",
                    as: Bool.self
                )
            }
        }

        let connection: any DatabaseConnection

        func items(
            searchPattern: String?,
            formKey: String?,
            isUnassigned: Bool,
            sort: [FormField.Search.Input.Query.Sort],
            pageSize: Int,
            offset: Int
        ) async throws -> [Item] {
            try await connection.run(
                query: itemsQuery(
                    searchPattern: searchPattern,
                    formKey: formKey,
                    isUnassigned: isUnassigned,
                    sort: sort,
                    pageSize: pageSize,
                    offset: offset
                )
            ) { rows in
                try await rows.collect().map { try Item(from: $0) }
            }
        }

        func count(
            searchPattern: String?,
            formKey: String?,
            isUnassigned: Bool
        ) async throws -> Int {
            try await connection.run(
                query: countQuery(
                    searchPattern: searchPattern,
                    formKey: formKey,
                    isUnassigned: isUnassigned
                )
            ) { rows in
                guard let row = try await rows.first() else { return 0 }
                return try row.decode(column: "count", as: Int.self)
            }
        }

        private func itemsQuery(
            searchPattern: String?,
            formKey: String?,
            isUnassigned: Bool,
            sort: [FormField.Search.Input.Query.Sort],
            pageSize: Int,
            offset: Int
        ) -> DatabaseQuery {
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 700,
                interpolationCount: 9
            )
            sql.appendLiteral(
                """
                SELECT field.id, field.key, field.type, field.label, field.is_required
                FROM contact_form_field AS field
                WHERE (
                """
            )
            appendSearchFilter(searchPattern, to: &sql)
            sql.appendLiteral(") AND (")
            appendFormFilter(formKey, isUnassigned: isUnassigned, to: &sql)
            sql.appendLiteral(") ORDER BY ")
            for index in sort.indices {
                let rule = sort[index]
                if index > 0 { sql.appendLiteral(", ") }
                sql.appendLiteral(orderColumn(for: rule.field))
                sql.appendLiteral(rule.direction == .asc ? " ASC" : " DESC")
            }
            if sort.isEmpty {
                sql.appendLiteral("field.key ASC")
            }
            sql.appendLiteral(", field.id ASC LIMIT ")
            sql.appendInterpolation(pageSize)
            sql.appendLiteral(" OFFSET ")
            sql.appendInterpolation(offset)
            sql.appendLiteral(";")
            return .init(stringInterpolation: sql)
        }

        private func countQuery(
            searchPattern: String?,
            formKey: String?,
            isUnassigned: Bool
        ) -> DatabaseQuery {
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 680,
                interpolationCount: 6
            )
            sql.appendLiteral(
                """
                SELECT COUNT(*) AS count
                FROM contact_form_field AS field
                WHERE (
                """
            )
            appendSearchFilter(searchPattern, to: &sql)
            sql.appendLiteral(") AND (")
            appendFormFilter(formKey, isUnassigned: isUnassigned, to: &sql)
            sql.appendLiteral(");")
            return .init(stringInterpolation: sql)
        }

        private func appendSearchFilter(
            _ searchPattern: String?,
            to sql: inout DatabaseQuery.StringInterpolation
        ) {
            guard let searchPattern else {
                sql.appendLiteral("TRUE")
                return
            }
            sql.appendLiteral("LOWER(field.key) LIKE LOWER(")
            sql.appendInterpolation(searchPattern)
            sql.appendLiteral(") ESCAPE '!'")
            sql.appendLiteral(" OR LOWER(field.label) LIKE LOWER(")
            sql.appendInterpolation(searchPattern)
            sql.appendLiteral(") ESCAPE '!'")
        }

        private func appendFormFilter(
            _ formKey: String?,
            isUnassigned: Bool,
            to sql: inout DatabaseQuery.StringInterpolation
        ) {
            if let formKey {
                sql.appendLiteral(
                    """
                    EXISTS (
                        SELECT 1
                        FROM contact_form_form_field AS assignment
                        INNER JOIN contact_form AS form ON form.id = assignment.form_id
                        WHERE assignment.field_id = field.id AND form.key =
                    """
                )
                sql.appendInterpolation(formKey)
                sql.appendLiteral(")")
            }
            else if isUnassigned {
                sql.appendLiteral(
                    """
                    NOT EXISTS (
                        SELECT 1
                        FROM contact_form_form_field AS assignment
                        WHERE assignment.field_id = field.id
                    )
                    """
                )
            }
            else {
                sql.appendLiteral("TRUE")
            }
        }

        private func orderColumn(
            for field: FormField.Search.Input.Query.Sort.Field
        ) -> String {
            switch field {
            case .key: "field.key"
            case .label: "field.label"
            case .type: "field.type"
            case .isRequired: "field.is_required"
            }
        }
    }
}
