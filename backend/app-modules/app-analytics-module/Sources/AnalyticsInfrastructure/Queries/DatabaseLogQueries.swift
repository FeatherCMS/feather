import AnalyticsApplication
import Application
import FeatherDatabase
import Foundation
import Infrastructure

extension LogTable.Row {
    var asQueryListItem: LogList.Item {
        .init(
            id: id,
            accountId: accountId,
            source: source,
            method: method,
            path: path,
            responseCode: responseCode,
            ip: ip,
            browserName: browserName,
            createdAt: createdAt.timeIntervalSince1970
        )
    }
}

public struct DatabaseLogQueries: LogQueries {

    struct OverviewBreakdownRow {
        let label: String
        let count: Int
    }

    struct OverviewKPIRow {
        let totalRequests: Int
        let authenticatedRequests: Int
        let notFoundRequests: Int
        let clientErrorRequests: Int
        let serverErrorRequests: Int
    }

    struct OverviewDailyRow {
        let bucket: Double
        let requests: Int
        let notFoundRequests: Int
        let clientErrorRequests: Int
        let serverErrorRequests: Int
    }

    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    func pageSizeOffset(
        _ page: Search.Page
    ) -> (size: Int, offset: Int) {
        let size = max(1, page.size)
        let number = max(1, page.number)
        return (size, (number - 1) * size)
    }

    func sortDirectionSQL(
        _ direction: Search.SortDirection
    ) -> String {
        switch direction {
        case .asc:
            "ASC"
        case .desc:
            "DESC"
        }
    }

    func orderByAnalyticsLog(
        _ query: LogList.Query
    ) -> String {
        let sortParts = query.sort.map { log -> String in
            let column: String
            switch log.field {
            case .id:
                column = "id"
            case .accountId:
                column = "account_id"
            case .method:
                column = "method"
            case .source:
                column = "source"
            case .path:
                column = "path"
            case .responseCode:
                column = "response_code"
            case .ip:
                column = "ip"
            case .browserName:
                column = "browser_name"
            case .createdAt:
                column = "created_at"
            }
            return "\(column) \(sortDirectionSQL(log.direction))"
        }
        return (sortParts + ["created_at DESC", "id ASC"])
            .joined(separator: ", ")
    }

    public func list(
        query: LogList.Query
    ) async throws -> LogList {
        let page = pageSizeOffset(query.page)
        let table = LogTable(connection: connection)
        let items =
            try await table.list(
                search: query.search,
                source: query.source,
                method: query.method,
                responseCode: query.responseCode,
                orderBy: orderByAnalyticsLog(query),
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: LogList.Query
    ) async throws -> Int {
        let table = LogTable(connection: connection)
        return try await table.count(
            search: query.search,
            source: query.source,
            method: query.method,
            responseCode: query.responseCode
        )
    }

    func overviewDate(
        _ timestamp: Double
    ) -> Date {
        Date(timeIntervalSince1970: timestamp)
    }

    func overviewShare(
        count: Int,
        total: Int
    ) -> Double {
        guard total > 0 else {
            return 0
        }
        return Double(count) / Double(total)
    }

    func overviewDays(
        from: Date,
        to: Date
    ) -> Double {
        let seconds = max(86_400, to.timeIntervalSince(from))
        return max(1, ceil(seconds / 86_400))
    }

    func analyticsLogColumns() async throws -> Set<String> {
        try await connection.run(
            query: #"""
                SELECT column_name
                FROM information_schema.columns
                WHERE table_schema = 'public'
                    AND table_name = 'analytics_log';
                """#
        ) { sequence in
            Set(
                try await sequence.collect()
                    .compactMap { row in
                        try row.decode(column: "column_name", as: String.self)
                    }
            )
        }
    }

    func decodeOverviewKPI(
        source: String,
        from: Date,
        to: Date,
        columns: Set<String>
    ) async throws -> OverviewKPIRow {
        let fromTimestamp = from.timeIntervalSince1970
        let toTimestamp = to.timeIntervalSince1970
        let authenticatedRequestsSQL =
            columns.contains("account_id")
            ? "COUNT(*) FILTER (WHERE account_id IS NOT NULL) AS authenticated_requests"
            : "0 AS authenticated_requests"
        let notFoundRequestsSQL =
            columns.contains("response_code")
            ? "COUNT(*) FILTER (WHERE response_code = 404) AS not_found_requests"
            : "0 AS not_found_requests"
        let clientErrorRequestsSQL =
            columns.contains("response_code")
            ? "COUNT(*) FILTER (WHERE response_code BETWEEN 400 AND 499) AS client_error_requests"
            : "0 AS client_error_requests"
        let serverErrorRequestsSQL =
            columns.contains("response_code")
            ? "COUNT(*) FILTER (WHERE response_code >= 500) AS server_error_requests"
            : "0 AS server_error_requests"
        let whereSQL = overviewWhereSQL(
            source: source,
            columns: columns
        )
        let query: DatabaseQuery
        if columns.contains("source") {
            query = #"""
                SELECT
                    COUNT(*) AS total_requests,
                    \#(unescaped: authenticatedRequestsSQL),
                    \#(unescaped: notFoundRequestsSQL),
                    \#(unescaped: clientErrorRequestsSQL),
                    \#(unescaped: serverErrorRequestsSQL)
                FROM analytics_log
                WHERE created_at >= TO_TIMESTAMP(\#(fromTimestamp))
                    AND created_at < TO_TIMESTAMP(\#(toTimestamp))
                    AND source = \#(source)
                    AND \#(unescaped: whereSQL);
                """#
        }
        else {
            query = #"""
                SELECT
                    COUNT(*) AS total_requests,
                    \#(unescaped: authenticatedRequestsSQL),
                    \#(unescaped: notFoundRequestsSQL),
                    \#(unescaped: clientErrorRequestsSQL),
                    \#(unescaped: serverErrorRequestsSQL)
                FROM analytics_log
                WHERE created_at >= TO_TIMESTAMP(\#(fromTimestamp))
                    AND created_at < TO_TIMESTAMP(\#(toTimestamp))
                    AND \#(unescaped: whereSQL);
                """#
        }
        return try await connection.run(query: query) { sequence in
            guard let row = try await sequence.collect().first else {
                return OverviewKPIRow(
                    totalRequests: 0,
                    authenticatedRequests: 0,
                    notFoundRequests: 0,
                    clientErrorRequests: 0,
                    serverErrorRequests: 0
                )
            }
            return OverviewKPIRow(
                totalRequests: try row.decode(
                    column: "total_requests",
                    as: Int.self
                ),
                authenticatedRequests: try row.decode(
                    column: "authenticated_requests",
                    as: Int.self
                ),
                notFoundRequests: try row.decode(
                    column: "not_found_requests",
                    as: Int.self
                ),
                clientErrorRequests: try row.decode(
                    column: "client_error_requests",
                    as: Int.self
                ),
                serverErrorRequests: try row.decode(
                    column: "server_error_requests",
                    as: Int.self
                )
            )
        }
    }

    func decodeOverviewDaily(
        source: String,
        from: Date,
        to: Date,
        columns: Set<String>
    ) async throws -> [OverviewDailyRow] {
        let fromTimestamp = from.timeIntervalSince1970
        let toTimestamp = to.timeIntervalSince1970
        let notFoundRequestsSQL =
            columns.contains("response_code")
            ? "COUNT(log.id) FILTER (WHERE log.response_code = 404) AS not_found_requests"
            : "0 AS not_found_requests"
        let clientErrorRequestsSQL =
            columns.contains("response_code")
            ? "COUNT(log.id) FILTER (WHERE log.response_code BETWEEN 400 AND 499) AS client_error_requests"
            : "0 AS client_error_requests"
        let serverErrorRequestsSQL =
            columns.contains("response_code")
            ? "COUNT(log.id) FILTER (WHERE log.response_code >= 500) AS server_error_requests"
            : "0 AS server_error_requests"
        let joinWhereSQL = overviewWhereSQL(
            source: source,
            columns: columns,
            pathExpression: "log.path"
        )
        let query: DatabaseQuery
        if columns.contains("source") {
            query = #"""
                WITH buckets AS (
                    SELECT generate_series(
                        date_trunc('day', TO_TIMESTAMP(\#(fromTimestamp))),
                        date_trunc('day', TO_TIMESTAMP(\#(toTimestamp)) - interval '1 second'),
                        interval '1 day'
                    ) AS bucket
                )
                SELECT
                    CAST(EXTRACT(EPOCH FROM bucket) AS DOUBLE PRECISION) AS bucket,
                    COUNT(log.id) AS requests,
                    \#(unescaped: notFoundRequestsSQL),
                    \#(unescaped: clientErrorRequestsSQL),
                    \#(unescaped: serverErrorRequestsSQL)
                FROM buckets
                LEFT JOIN analytics_log AS log
                    ON log.created_at >= bucket
                    AND log.created_at < bucket + interval '1 day'
                    AND log.source = \#(source)
                    AND \#(unescaped: joinWhereSQL)
                GROUP BY bucket
                ORDER BY bucket ASC;
                """#
        }
        else {
            query = #"""
                WITH buckets AS (
                    SELECT generate_series(
                        date_trunc('day', TO_TIMESTAMP(\#(fromTimestamp))),
                        date_trunc('day', TO_TIMESTAMP(\#(toTimestamp)) - interval '1 second'),
                        interval '1 day'
                    ) AS bucket
                )
                SELECT
                    CAST(EXTRACT(EPOCH FROM bucket) AS DOUBLE PRECISION) AS bucket,
                    COUNT(log.id) AS requests,
                    \#(unescaped: notFoundRequestsSQL),
                    \#(unescaped: clientErrorRequestsSQL),
                    \#(unescaped: serverErrorRequestsSQL)
                FROM buckets
                LEFT JOIN analytics_log AS log
                    ON log.created_at >= bucket
                    AND log.created_at < bucket + interval '1 day'
                    AND \#(unescaped: joinWhereSQL)
                GROUP BY bucket
                ORDER BY bucket ASC;
                """#
        }
        return try await connection.run(query: query) { sequence in
            try await sequence.collect()
                .map { row in
                    OverviewDailyRow(
                        bucket: try row.decode(
                            column: "bucket",
                            as: Double.self
                        ),
                        requests: try row.decode(
                            column: "requests",
                            as: Int.self
                        ),
                        notFoundRequests: try row.decode(
                            column: "not_found_requests",
                            as: Int.self
                        ),
                        clientErrorRequests: try row.decode(
                            column: "client_error_requests",
                            as: Int.self
                        ),
                        serverErrorRequests: try row.decode(
                            column: "server_error_requests",
                            as: Int.self
                        )
                    )
                }
        }
    }

    func decodeOverviewBreakdown(
        source: String,
        from: Date,
        to: Date,
        columns: Set<String>,
        requiredColumns: [String] = [],
        labelSQL: String,
        whereSQL: String = "TRUE",
        limit: Int = 10
    ) async throws -> [OverviewBreakdownRow] {
        guard requiredColumns.allSatisfy(columns.contains) else {
            return []
        }
        let fromTimestamp = from.timeIntervalSince1970
        let toTimestamp = to.timeIntervalSince1970
        let combinedWhereSQL = overviewWhereSQL(
            source: source,
            columns: columns,
            whereSQL: whereSQL
        )
        let query: DatabaseQuery
        if columns.contains("source") {
            query = #"""
                SELECT
                    \#(unescaped: labelSQL) AS label,
                    COUNT(*) AS count
                FROM analytics_log
                WHERE created_at >= TO_TIMESTAMP(\#(fromTimestamp))
                    AND created_at < TO_TIMESTAMP(\#(toTimestamp))
                    AND source = \#(source)
                    AND \#(unescaped: combinedWhereSQL)
                GROUP BY \#(unescaped: labelSQL)
                ORDER BY count DESC, label ASC
                LIMIT \#(limit);
                """#
        }
        else {
            query = #"""
                SELECT
                    \#(unescaped: labelSQL) AS label,
                    COUNT(*) AS count
                FROM analytics_log
                WHERE created_at >= TO_TIMESTAMP(\#(fromTimestamp))
                    AND created_at < TO_TIMESTAMP(\#(toTimestamp))
                    AND \#(unescaped: combinedWhereSQL)
                GROUP BY \#(unescaped: labelSQL)
                ORDER BY count DESC, label ASC
                LIMIT \#(limit);
                """#
        }
        return try await connection.run(query: query) { sequence in
            try await sequence.collect()
                .map { row in
                    OverviewBreakdownRow(
                        label: try row.decode(column: "label", as: String.self),
                        count: try row.decode(column: "count", as: Int.self)
                    )
                }
        }
    }

    func mapOverviewBreakdown(
        _ rows: [OverviewBreakdownRow],
        total: Int
    ) -> [LogOverview.BreakdownItem] {
        rows.map { row in
            .init(
                label: row.label,
                count: row.count,
                share: overviewShare(count: row.count, total: total)
            )
        }
    }

    func overviewIncludedPathsWhereSQL(
        source: String,
        columns: Set<String>,
        pathExpression: String = "path"
    ) -> String {
        guard source == "web_app", columns.contains("path") else {
            return "TRUE"
        }
        return """
            \(pathExpression) NOT LIKE '/admin/%'
            AND \(pathExpression) NOT LIKE '/.well-known/%'
            AND \(pathExpression) <> '/favicon.ico'
            """
    }

    func overviewWhereSQL(
        source: String,
        columns: Set<String>,
        whereSQL: String = "TRUE",
        pathExpression: String = "path"
    ) -> String {
        let includedPathsWhereSQL = overviewIncludedPathsWhereSQL(
            source: source,
            columns: columns,
            pathExpression: pathExpression
        )
        guard includedPathsWhereSQL != "TRUE" else {
            return whereSQL
        }
        guard whereSQL != "TRUE" else {
            return includedPathsWhereSQL
        }
        return "(\(whereSQL)) AND (\(includedPathsWhereSQL))"
    }

    public func overview(
        query: LogOverview.Query
    ) async throws -> LogOverview {
        let from = overviewDate(query.from)
        let to = overviewDate(query.to)
        let columns = try await analyticsLogColumns()
        let kpiRow = try await decodeOverviewKPI(
            source: query.source,
            from: from,
            to: to,
            columns: columns
        )
        let dailyRows = try await decodeOverviewDaily(
            source: query.source,
            from: from,
            to: to,
            columns: columns
        )
        let total = kpiRow.totalRequests
        let averageRequestsPerDay =
            Double(total)
            / overviewDays(
                from: from,
                to: to
            )

        // Run these sequentially because the query executor gives us a single
        // database connection for the request scope.
        let statusFamilies = try await decodeOverviewBreakdown(
            source: query.source,
            from: from,
            to: to,
            columns: columns,
            requiredColumns: ["response_code"],
            labelSQL: """
                CASE
                    WHEN response_code BETWEEN 200 AND 299 THEN '2xx'
                    WHEN response_code BETWEEN 300 AND 399 THEN '3xx'
                    WHEN response_code BETWEEN 400 AND 499 THEN '4xx'
                    ELSE '5xx'
                END
                """,
            limit: 5
        )
        let methods = try await decodeOverviewBreakdown(
            source: query.source,
            from: from,
            to: to,
            columns: columns,
            requiredColumns: ["method"],
            labelSQL: "method"
        )
        let paths = try await decodeOverviewBreakdown(
            source: query.source,
            from: from,
            to: to,
            columns: columns,
            requiredColumns: ["path"],
            labelSQL: "path"
        )
        let notFoundPaths = try await decodeOverviewBreakdown(
            source: query.source,
            from: from,
            to: to,
            columns: columns,
            requiredColumns: ["path", "response_code"],
            labelSQL: "path",
            whereSQL: "response_code = 404"
        )
        let serverErrorPaths = try await decodeOverviewBreakdown(
            source: query.source,
            from: from,
            to: to,
            columns: columns,
            requiredColumns: ["path", "response_code"],
            labelSQL: "path",
            whereSQL: "response_code >= 500"
        )
        let referrers = try await decodeOverviewBreakdown(
            source: query.source,
            from: from,
            to: to,
            columns: columns,
            requiredColumns: ["referer"],
            labelSQL: "COALESCE(NULLIF(referer, ''), '(Direct)')"
        )
        let browsers = try await decodeOverviewBreakdown(
            source: query.source,
            from: from,
            to: to,
            columns: columns,
            requiredColumns: ["browser_name"],
            labelSQL: "COALESCE(NULLIF(browser_name, ''), 'Unknown')"
        )
        let operatingSystems = try await decodeOverviewBreakdown(
            source: query.source,
            from: from,
            to: to,
            columns: columns,
            requiredColumns: ["os_name"],
            labelSQL: "COALESCE(NULLIF(os_name, ''), 'Unknown')"
        )
        let deviceTypes = try await decodeOverviewBreakdown(
            source: query.source,
            from: from,
            to: to,
            columns: columns,
            requiredColumns: ["device_type"],
            labelSQL: "COALESCE(NULLIF(device_type, ''), 'Unknown')"
        )
        let languages = try await decodeOverviewBreakdown(
            source: query.source,
            from: from,
            to: to,
            columns: columns,
            requiredColumns: ["language"],
            labelSQL: "COALESCE(NULLIF(language, ''), 'Unknown')"
        )
        let regions = try await decodeOverviewBreakdown(
            source: query.source,
            from: from,
            to: to,
            columns: columns,
            requiredColumns: ["region"],
            labelSQL: "COALESCE(NULLIF(region, ''), 'Unknown')"
        )

        return .init(
            query: query,
            kpis: .init(
                totalRequests: total,
                averageRequestsPerDay: averageRequestsPerDay,
                authenticatedRequests: kpiRow.authenticatedRequests,
                notFoundRequests: kpiRow.notFoundRequests,
                clientErrorRequests: kpiRow.clientErrorRequests,
                serverErrorRequests: kpiRow.serverErrorRequests
            ),
            daily: dailyRows.map { row in
                .init(
                    bucket: row.bucket,
                    requests: row.requests,
                    notFoundRequests: row.notFoundRequests,
                    clientErrorRequests: row.clientErrorRequests,
                    serverErrorRequests: row.serverErrorRequests
                )
            },
            statusFamilies: mapOverviewBreakdown(statusFamilies, total: total),
            methods: mapOverviewBreakdown(methods, total: total),
            paths: mapOverviewBreakdown(paths, total: total),
            notFoundPaths: mapOverviewBreakdown(notFoundPaths, total: total),
            serverErrorPaths: mapOverviewBreakdown(
                serverErrorPaths,
                total: total
            ),
            referrers: mapOverviewBreakdown(referrers, total: total),
            browsers: mapOverviewBreakdown(browsers, total: total),
            operatingSystems: mapOverviewBreakdown(
                operatingSystems,
                total: total
            ),
            deviceTypes: mapOverviewBreakdown(deviceTypes, total: total),
            languages: mapOverviewBreakdown(languages, total: total),
            regions: mapOverviewBreakdown(regions, total: total)
        )
    }

    public func find(
        id: String
    ) async throws -> LogDetail {
        let table = LogTable(connection: connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDomain.asDetail
    }
}
