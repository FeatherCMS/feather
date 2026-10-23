public import ContactApplication
import ContactDomain
public import ContactModule
import FeatherApplication
import FeatherDatabase
public import FeatherInfrastructure
import Foundation

extension Submission.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: Submission.Search.Input.Query
        ) async throws -> Submission.Search.Output {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let searchPattern: String? = query.search.flatMap {
                value -> String? in
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
                    sort: query.sort,
                    pageSize: page.size,
                    offset: offset
                )
            ) { rows in
                try await rows.collect()
                    .map { row in
                        let statusValue = try row.decode(
                            column: "submission_status",
                            as: String.self
                        )
                        guard
                            let status = Submission.Model.Status(
                                rawValue: statusValue
                            )
                        else {
                            throw RepositoryError.invalidEnumValue(statusValue)
                        }
                        let valuesJSON = try row.decode(
                            column: "submission_values",
                            as: String.self
                        )
                        return Submission.Search.Output.Item(
                            id: try row.decode(
                                column: "submission_id",
                                as: String.self
                            ),
                            formKey: try row.decode(
                                column: "form_key",
                                as: String.self
                            ),
                            formName: try row.decode(
                                column: "form_name",
                                as: String.self
                            ),
                            status: status,
                            createdAt: try row.decode(
                                column: "created_at",
                                as: Date.self
                            ),
                            email: Self.email(from: valuesJSON)
                        )
                    }
            }
            let total = try await context.connection.run(
                query: countQuery(
                    searchPattern: searchPattern,
                    formKey: query.formKey
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
            sort: [Submission.Search.Input.Query.Sort],
            pageSize: Int,
            offset: Int
        ) -> DatabaseQuery {
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 760,
                interpolationCount: 7
            )
            sql.appendLiteral(
                """
                SELECT s.id AS submission_id, f.key AS form_key,
                       f.name AS form_name, s.status AS submission_status,
                       s.created_at AS created_at, s.values AS submission_values
                FROM contact_form_submission AS s
                INNER JOIN contact_form AS f ON f.id = s.form_id
                WHERE (
                """
            )
            appendSearchFilter(searchPattern, to: &sql)
            sql.appendLiteral(") AND ( ")
            appendFormKeyFilter(formKey, to: &sql)
            sql.appendLiteral(") ORDER BY ")
            for (index, rule) in sort.enumerated() {
                if index > 0 { sql.appendLiteral(", ") }
                sql.appendLiteral(orderColumn(for: rule.field))
                sql.appendLiteral(rule.direction == .asc ? " ASC" : " DESC")
            }
            if sort.isEmpty {
                sql.appendLiteral("s.created_at DESC")
            }
            sql.appendLiteral(", s.id DESC LIMIT ")
            sql.appendInterpolation(pageSize)
            sql.appendLiteral(" OFFSET ")
            sql.appendInterpolation(offset)
            sql.appendLiteral(";")
            return .init(stringInterpolation: sql)
        }

        private func countQuery(
            searchPattern: String?,
            formKey: String?
        ) -> DatabaseQuery {
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 560,
                interpolationCount: 5
            )
            sql.appendLiteral(
                """
                SELECT COUNT(*) AS count
                FROM contact_form_submission AS s
                INNER JOIN contact_form AS f ON f.id = s.form_id
                WHERE (
                """
            )
            appendSearchFilter(searchPattern, to: &sql)
            sql.appendLiteral(") AND ( ")
            appendFormKeyFilter(formKey, to: &sql)
            sql.appendLiteral(");")
            return .init(stringInterpolation: sql)
        }

        private func appendFormKeyFilter(
            _ formKey: String?,
            to sql: inout DatabaseQuery.StringInterpolation
        ) {
            guard let formKey else {
                sql.appendLiteral("TRUE")
                return
            }
            sql.appendLiteral("f.key = ")
            sql.appendInterpolation(formKey)
        }

        private func appendSearchFilter(
            _ searchPattern: String?,
            to sql: inout DatabaseQuery.StringInterpolation
        ) {
            guard let searchPattern else {
                sql.appendLiteral("TRUE")
                return
            }
            sql.appendLiteral("LOWER(s.id) LIKE LOWER(")
            sql.appendInterpolation(searchPattern)
            sql.appendLiteral(") ESCAPE '!'")
            sql.appendLiteral(" OR LOWER(f.key) LIKE LOWER(")
            sql.appendInterpolation(searchPattern)
            sql.appendLiteral(") ESCAPE '!'")
            sql.appendLiteral(" OR LOWER(f.name) LIKE LOWER(")
            sql.appendInterpolation(searchPattern)
            sql.appendLiteral(") ESCAPE '!'")
            sql.appendLiteral(" OR LOWER(s.status) LIKE LOWER(")
            sql.appendInterpolation(searchPattern)
            sql.appendLiteral(") ESCAPE '!'")
        }

        private func orderColumn(
            for field: Submission.Search.Input.Query.Sort.Field
        ) -> String {
            switch field {
            case .createdAt: "s.created_at"
            case .formName: "f.name"
            case .status: "s.status"
            }
        }

        private static func email(from valuesJSON: String) -> String? {
            guard
                let data = valuesJSON.data(using: .utf8),
                let object = try? JSONSerialization.jsonObject(with: data),
                let values = object as? [String: Any],
                let email = values.first(where: {
                    $0.key.localizedCaseInsensitiveCompare("email")
                        == .orderedSame
                })?
                .value as? String
            else {
                return nil
            }
            return email
        }
    }
}
