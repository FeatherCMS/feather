import ContactApplication
import ContactModule
import FeatherApplication
import FeatherDatabase
import Foundation

struct SubmissionSearchQueryTable: Sendable {
    struct Item: Sendable {
        let submissionID: String
        let formKey: String
        let formName: String
        let status: String
        let createdAt: Date
        let valuesJSON: String

        init(from row: any DatabaseRow) throws {
            submissionID = try row.decode(
                column: "submission_id",
                as: String.self
            )
            formKey = try row.decode(column: "form_key", as: String.self)
            formName = try row.decode(column: "form_name", as: String.self)
            status = try row.decode(
                column: "submission_status",
                as: String.self
            )
            createdAt = try row.decode(column: "created_at", as: Date.self)
            valuesJSON = try row.decode(
                column: "submission_values",
                as: String.self
            )
        }
    }

    let connection: any DatabaseConnection

    func items(
        searchPattern: String?,
        formKey: String?,
        sort: [Submission.Search.Input.Query.Sort],
        pageSize: Int,
        offset: Int
    ) async throws -> [Item] {
        try await connection.run(
            query: itemsQuery(
                searchPattern: searchPattern,
                formKey: formKey,
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
        formKey: String?
    ) async throws -> Int {
        try await connection.run(
            query: countQuery(
                searchPattern: searchPattern,
                formKey: formKey
            )
        ) { rows in
            guard let row = try await rows.first() else { return 0 }
            return try row.decode(column: "count", as: Int.self)
        }
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
}
