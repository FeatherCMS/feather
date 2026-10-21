import FeatherApplication
import FeatherDatabase
public import FeatherInfrastructure
import Foundation
public import SystemApplication
public import SystemModule

extension SystemModule.Job.Search.Query {
    public struct Database: SystemModule.Job.Search.Query.Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: SystemModule.Job.Search.Input.Query
        ) async throws -> SystemModule.Job.Search.Output {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let searchPattern = query.search.map {
                "%"
                    + $0
                    .replacingOccurrences(of: "!", with: "!!")
                    .replacingOccurrences(of: "%", with: "!%")
                    .replacingOccurrences(of: "_", with: "!_") + "%"
            }
            let status = query.status
            let direction = query.sort.first?.direction
            let orderDirection = direction == .asc ? " ASC" : " DESC"

            let items = try await context.connection.run(
                query: searchItemsQuery(
                    searchPattern: searchPattern,
                    status: status,
                    pageSize: page.size,
                    offset: offset,
                    orderDirection: orderDirection
                )
            ) { sequence in
                try await sequence.collect().map { try JobRow(from: $0).detail }
            }
            let total = try await context.connection.run(
                query: countQuery(searchPattern: searchPattern, status: status)
            ) { sequence in
                guard let row = try await sequence.collect().first else {
                    return 0
                }
                return try row.decode(column: "count", as: Int.self)
            }

            return .init(items: items, total: total)
        }

        private func searchItemsQuery(
            searchPattern: String?,
            status: Int?,
            pageSize: Int,
            offset: Int,
            orderDirection: String
        ) -> DatabaseQuery {
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 700,
                interpolationCount: 12
            )
            sql.appendLiteral(
                """
                SELECT id::text, queue_name, status, worker_id, last_modified,
                       convert_from(job, 'UTF8') AS payload
                FROM swift_jobs.jobs
                WHERE (
                """
            )
            appendFilters(&sql, searchPattern: searchPattern, status: status)
            sql.appendLiteral(
                """
                 ORDER BY (
                    SELECT CASE
                        WHEN job_payload ->> 'q' ~ '^-?[0-9]+([.][0-9]+)?$'
                        THEN (job_payload ->> 'q')::double precision
                    END
                    FROM jsonb_each(convert_from(job, 'UTF8')::jsonb)
                        AS queued_job(job_name, job_payload)
                    LIMIT 1
                )
                """
            )
            sql.appendLiteral(orderDirection)
            sql.appendLiteral(" NULLS LAST, id DESC LIMIT ")
            sql.appendInterpolation(pageSize)
            sql.appendLiteral(" OFFSET ")
            sql.appendInterpolation(offset)
            sql.appendLiteral(";")
            return DatabaseQuery(stringInterpolation: sql)
        }

        private func countQuery(
            searchPattern: String?,
            status: Int?
        ) -> DatabaseQuery {
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 600,
                interpolationCount: 10
            )
            sql.appendLiteral(
                """
                SELECT COUNT(*) AS count
                FROM swift_jobs.jobs
                WHERE (
                """
            )
            appendFilters(&sql, searchPattern: searchPattern, status: status)
            sql.appendLiteral(";")
            return DatabaseQuery(stringInterpolation: sql)
        }

        private func appendFilters(
            _ sql: inout DatabaseQuery.StringInterpolation,
            searchPattern: String?,
            status: Int?
        ) {
            sql.appendInterpolation(searchPattern)
            sql.appendLiteral(" IS NULL OR id::text ILIKE ")
            sql.appendInterpolation(searchPattern)
            sql.appendLiteral(" ESCAPE '!'")
            sql.appendLiteral(" OR queue_name ILIKE ")
            sql.appendInterpolation(searchPattern)
            sql.appendLiteral(" ESCAPE '!'")
            sql.appendLiteral(" OR worker_id::text ILIKE ")
            sql.appendInterpolation(searchPattern)
            sql.appendLiteral(" ESCAPE '!'")
            sql.appendLiteral(" OR status::text ILIKE ")
            sql.appendInterpolation(searchPattern)
            sql.appendLiteral(" ESCAPE '!'")
            sql.appendLiteral(" OR convert_from(job, 'UTF8') ILIKE ")
            sql.appendInterpolation(searchPattern)
            sql.appendLiteral(" ESCAPE '!') AND (")
            sql.appendInterpolation(status)
            sql.appendLiteral(" IS NULL OR status = ")
            sql.appendInterpolation(status)
            sql.appendLiteral(")")
        }
    }
}
