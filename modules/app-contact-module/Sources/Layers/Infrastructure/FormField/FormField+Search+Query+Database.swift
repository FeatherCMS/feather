public import ContactApplication
import ContactDomain
public import ContactModule
import FeatherApplication
import FeatherDatabase
public import FeatherInfrastructure
import Foundation

extension FormField.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: FormField.Search.Input.Query
        ) async throws -> FormField.Search.Output {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset = pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let searchPattern = query.search.flatMap { value -> String? in
                guard !value.isEmpty else { return nil }
                return "%"
                    + value
                    .replacingOccurrences(of: "!", with: "!!")
                    .replacingOccurrences(of: "%", with: "!%")
                    .replacingOccurrences(of: "_", with: "!_")
                    + "%"
            }
            let items = try await context.connection.run(
                query: itemsQuery(
                    searchPattern: searchPattern,
                    formKey: query.formKey,
                    isUnassigned: query.isUnassigned,
                    sort: query.sort,
                    pageSize: page.size,
                    offset: offset
                )
            ) { rows in
                try await rows.collect().map { row in
                    let typeValue = try row.decode(
                        column: "type",
                        as: String.self
                    )
                    guard let type = FormField.Model.ItemType(rawValue: typeValue)
                    else {
                        throw RepositoryError.invalidEnumValue(typeValue)
                    }
                    return FormField.Search.Output.Item(
                        id: try row.decode(column: "id", as: String.self),
                        key: try row.decode(column: "key", as: String.self),
                        type: type,
                        label: try row.decode(column: "label", as: String.self),
                        isRequired: try row.decode(
                            column: "is_required",
                            as: Bool.self
                        )
                    )
                }
            }
            let total = try await context.connection.run(
                query: countQuery(
                    searchPattern: searchPattern,
                    formKey: query.formKey,
                    isUnassigned: query.isUnassigned
                )
            ) { rows in
                guard let row = try await rows.first() else { return 0 }
                return try row.decode(column: "count", as: Int.self)
            }
            return .init(items: items, total: total)
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
            for (index, rule) in sort.enumerated() {
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
