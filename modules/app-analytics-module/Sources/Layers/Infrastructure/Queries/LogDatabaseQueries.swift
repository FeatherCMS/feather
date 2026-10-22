//
//  LogDatabaseQueries.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AnalyticsApplication
import AnalyticsDomain
import FeatherApplication
import FeatherDBAL
import FeatherDatabase
public import AnalyticsModule
public import FeatherInfrastructure
import Foundation

extension LogTable.Row {
    var asQueryListItem: Log.List.Output.Item {
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

public struct LogDatabaseQueries: LogQueries {

    struct OverviewBreakdownRow {
        let category: String = ""
        let label: String
        let count: Int
    }

    struct OverviewBreakdownDimension {
        let category: String
        let column: String
    }

    struct OverviewKPIRow {
        let totalRequests: Int
        let authenticatedRequests: Int
        let notFoundRequests: Int
        let clientErrorRequests: Int
        let serverErrorRequests: Int
        let pageViews: Int
        let searchRequests: Int
        let botRequests: Int
        let aiRequests: Int
        let humanRequests: Int
    }

    struct OverviewDailyRow {
        let bucket: Double
        let requests: Int
        let notFoundRequests: Int
        let clientErrorRequests: Int
        let serverErrorRequests: Int
    }

    struct OverviewSummaryRow {
        let rowType: String
        let category: String
        let label: String?
        let bucket: Double?
        let totalRequests: Int?
        let requests: Int?
        let authenticatedRequests: Int?
        let notFoundRequests: Int?
        let clientErrorRequests: Int?
        let serverErrorRequests: Int?
        let pageViews: Int?
        let searchRequests: Int?
        let botRequests: Int?
        let aiRequests: Int?
        let humanRequests: Int?
        let uniqueVisitors: Int?
        let itemCount: Int?
    }

    public let context: DatabaseQueryContext

    public init(context: DatabaseQueryContext) {
        self.context = context
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
        _ query: Log.List.Input.Query
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
        query: Log.List.Input.Query
    ) async throws -> Log.List.Output {
        let page = pageSizeOffset(query.page)
        let table = LogTable(connection: context.connection)
        let items =
            try await table.list(
                search: query.search,
                source: query.source,
                method: query.method,
                responseCode: query.responseCode,
                from: query.from,
                to: query.to,
                orderBy: orderByAnalyticsLog(query),
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: Log.List.Input.Query
    ) async throws -> Int {
        let table = LogTable(connection: context.connection)
        return try await table.count(
            search: query.search,
            source: query.source,
            method: query.method,
            responseCode: query.responseCode,
            from: query.from,
            to: query.to
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

    func overviewAIPredicateSQL(columns: Set<String>) -> String {
        guard columns.contains("traffic_category") else { return "FALSE" }
        return "traffic_category = 'ai'"
    }

    func overviewBotPredicateSQL(columns: Set<String>) -> String {
        guard columns.contains("traffic_category") else { return "FALSE" }
        return "traffic_category IN ('bot', 'ai')"
    }

    func overviewOtherBotPredicateSQL(columns: Set<String>) -> String {
        guard columns.contains("traffic_category") else { return "FALSE" }
        return "traffic_category = 'bot'"
    }

    func overviewHumanPredicateSQL(columns: Set<String>) -> String {
        guard columns.contains("traffic_category") else { return "TRUE" }
        return "traffic_category = 'human'"
    }

    func overviewPageViewPredicateSQL(
        source: String,
        columns: Set<String>,
        tableAlias: String = ""
    ) -> String {
        guard source == "web_app" else { return "TRUE" }
        guard columns.isSuperset(of: ["method", "response_code"]) else {
            return "FALSE"
        }
        let prefix = tableAlias.isEmpty ? "" : "\(tableAlias)."
        let botPredicate = "\(prefix)traffic_category IN ('bot', 'ai')"
        return
            "\(prefix)method = 'GET' AND \(prefix)response_code BETWEEN 200 AND 299 AND NOT (\(botPredicate))"
    }

    func overviewTrafficCategorySQL(
        source: String,
        columns: Set<String>
    ) -> String {
        guard source == "web_app", columns.contains("traffic_category") else {
            return "'human'::text"
        }
        return "traffic_category"
    }

    func overviewDays(
        from: Date,
        to: Date
    ) -> Double {
        let seconds = max(86_400, to.timeIntervalSince(from))
        return max(1, ceil(seconds / 86_400))
    }

    func analyticsLogColumns() async throws -> Set<String> {
        try await context.connection.run(
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

    func overviewOptionalColumnSQL(
        _ column: String,
        columns: Set<String>,
        fallback: String
    ) -> String {
        columns.contains(column) ? column : fallback
    }

    func decodeOverviewSummary(
        source: String,
        from: Date,
        to: Date,
        columns: Set<String>,
        dashboardOnly: Bool,
        notFoundOnly: Bool = false
    ) async throws -> [OverviewSummaryRow] {
        let fromTimestamp = from.timeIntervalSince1970
        let toTimestamp = to.timeIntervalSince1970
        let accountIDSQL = overviewOptionalColumnSQL(
            "account_id",
            columns: columns,
            fallback: "NULL::text"
        )
        let ipSQL = overviewOptionalColumnSQL(
            "ip",
            columns: columns,
            fallback: "NULL::text"
        )
        let userAgentSQL = overviewOptionalColumnSQL(
            "user_agent",
            columns: columns,
            fallback: "NULL::text"
        )
        let responseCodeSQL = overviewOptionalColumnSQL(
            "response_code",
            columns: columns,
            fallback: "NULL::integer"
        )
        let methodSQL = overviewOptionalColumnSQL(
            "method",
            columns: columns,
            fallback: "NULL::text"
        )
        let pathSQL = overviewOptionalColumnSQL(
            "path",
            columns: columns,
            fallback: "NULL::text"
        )
        let trafficTypeSQL =
            notFoundOnly
            ? "'human'::text"
            : overviewTrafficCategorySQL(source: source, columns: columns)
        let baseWhereSQL = overviewWhereSQL(
            source: source,
            columns: columns
        )
        let whereSQL =
            notFoundOnly
            ? "(\(baseWhereSQL)) AND response_code = 404"
            : baseWhereSQL
        let pageViewPredicateSQL: String
        if source == "web_app",
            columns.isSuperset(of: ["method", "response_code"])
        {
            pageViewPredicateSQL =
                "method = 'GET' AND response_code BETWEEN 200 AND 299 AND traffic_type = 'human'"
        }
        else {
            pageViewPredicateSQL = "FALSE"
        }
        let chartRequestPredicateSQL =
            source == "web_app" ? "is_page_view" : "TRUE"
        let webSourceSQL = source == "web_app" ? "TRUE" : "FALSE"
        let visitorKeySQL: String
        let uniqueVisitorsAggregateSQL: String
        if source == "web_app",
            !dashboardOnly,
            !notFoundOnly,
            columns.isSuperset(of: ["method", "response_code"])
        {
            visitorKeySQL = """
                CASE
                    WHEN \(accountIDSQL) IS NOT NULL
                        THEN 'account:' || \(accountIDSQL)
                    WHEN \(ipSQL) IS NOT NULL
                        AND \(userAgentSQL) IS NOT NULL
                        THEN 'anonymous:' || MD5(
                            \(ipSQL) || CHR(31) || \(userAgentSQL)
                        )
                    ELSE NULL
                END
                """
            uniqueVisitorsAggregateSQL = """
                COUNT(DISTINCT visitor_key) FILTER (
                    WHERE is_page_view
                ) AS unique_visitors
                """
        }
        else {
            visitorKeySQL = "NULL::text"
            uniqueVisitorsAggregateSQL = "0::bigint AS unique_visitors"
        }

        let query: DatabaseQuery = #"""
            WITH base AS (
                SELECT
                    date_trunc('day', created_at) AS bucket,
                    (\#(unescaped: accountIDSQL) IS NOT NULL) AS is_authenticated,
                    \#(unescaped: responseCodeSQL) AS response_code,
                    \#(unescaped: methodSQL) AS method,
                    \#(unescaped: pathSQL) AS path,
                    \#(unescaped: trafficTypeSQL) AS traffic_type,
                    \#(unescaped: visitorKeySQL) AS visitor_key
                FROM analytics_log
                WHERE created_at >= TO_TIMESTAMP(\#(fromTimestamp))
                    AND created_at < TO_TIMESTAMP(\#(toTimestamp))
                    AND source = \#(source)
                    AND \#(unescaped: whereSQL)
            ),
            events AS (
                SELECT
                    base.*,
                    (\#(unescaped: pageViewPredicateSQL)) AS is_page_view
                FROM base
            ),
            aggregates AS (
                SELECT
                    bucket,
                    (GROUPING(bucket) = 1) AS is_total,
                    COUNT(*) AS total_requests,
                    COUNT(*) FILTER (
                        WHERE \#(unescaped: chartRequestPredicateSQL)
                    ) AS requests,
                    COUNT(*) FILTER (
                        WHERE is_authenticated
                    ) AS authenticated_requests,
                    COUNT(*) FILTER (
                        WHERE response_code = 404
                    ) AS not_found_requests,
                    COUNT(*) FILTER (
                        WHERE response_code BETWEEN 400 AND 499
                    ) AS client_error_requests,
                    COUNT(*) FILTER (
                        WHERE response_code >= 500
                    ) AS server_error_requests,
                    COUNT(*) FILTER (
                        WHERE \#(unescaped: webSourceSQL) AND is_page_view
                    ) AS page_views,
                    COUNT(*) FILTER (
                        WHERE \#(unescaped: webSourceSQL)
                            AND method = 'POST'
                            AND LOWER(TRIM(BOTH '/' FROM path)) = 'search'
                    ) AS search_requests,
                    COUNT(*) FILTER (
                        WHERE \#(unescaped: webSourceSQL)
                            AND traffic_type = 'bot'
                    ) AS bot_requests,
                    COUNT(*) FILTER (
                        WHERE \#(unescaped: webSourceSQL)
                            AND traffic_type = 'ai'
                    ) AS ai_requests,
                    COUNT(*) FILTER (
                        WHERE \#(unescaped: webSourceSQL)
                            AND traffic_type = 'human'
                    ) AS human_requests,
                    \#(unescaped: uniqueVisitorsAggregateSQL)
                FROM events
                GROUP BY GROUPING SETS ((bucket), ())
            ),
            buckets AS (
                SELECT generate_series(
                    date_trunc('day', TO_TIMESTAMP(\#(fromTimestamp))),
                    date_trunc(
                        'day',
                        TO_TIMESTAMP(\#(toTimestamp)) - interval '1 second'
                    ),
                    interval '1 day'
                ) AS bucket
            ),
            summary_rows AS (
                SELECT
                    'total'::text AS category,
                    NULL::double precision AS bucket,
                    total_requests,
                    NULL::bigint AS requests,
                    authenticated_requests,
                    not_found_requests,
                    client_error_requests,
                    server_error_requests,
                    page_views,
                    search_requests,
                    bot_requests,
                    ai_requests,
                    human_requests,
                    unique_visitors
                FROM aggregates
                WHERE is_total

                UNION ALL

                SELECT
                    'daily'::text AS category,
                    CAST(EXTRACT(EPOCH FROM buckets.bucket) AS DOUBLE PRECISION),
                    NULL::bigint AS total_requests,
                    COALESCE(aggregates.requests, 0),
                    NULL::bigint AS authenticated_requests,
                    COALESCE(aggregates.not_found_requests, 0),
                    COALESCE(aggregates.client_error_requests, 0),
                    COALESCE(aggregates.server_error_requests, 0),
                    NULL::bigint AS page_views,
                    NULL::bigint AS search_requests,
                    NULL::bigint AS bot_requests,
                    NULL::bigint AS ai_requests,
                    NULL::bigint AS human_requests,
                    NULL::bigint AS unique_visitors
                FROM buckets
                LEFT JOIN aggregates
                    ON aggregates.bucket = buckets.bucket
                    AND NOT aggregates.is_total
            )
            SELECT
                'summary'::text AS row_type,
                category,
                NULL::text AS label,
                bucket,
                total_requests,
                requests,
                authenticated_requests,
                not_found_requests,
                client_error_requests,
                server_error_requests,
                page_views,
                search_requests,
                bot_requests,
                ai_requests,
                human_requests,
                unique_visitors,
                NULL::bigint AS item_count
            FROM summary_rows
            ORDER BY category, bucket NULLS FIRST;
            """#
        return try await context.connection.run(query: query) { sequence in
            try await sequence.collect()
                .map { row in
                    OverviewSummaryRow(
                        rowType: try row.decode(
                            column: "row_type",
                            as: String.self
                        ),
                        category: try row.decode(
                            column: "category",
                            as: String.self
                        ),
                        label: try row.decode(
                            column: "label",
                            as: String?.self
                        ),
                        bucket: try row.decode(
                            column: "bucket",
                            as: Double?.self
                        ),
                        totalRequests: try row.decode(
                            column: "total_requests",
                            as: Int?.self
                        ),
                        requests: try row.decode(
                            column: "requests",
                            as: Int?.self
                        ),
                        authenticatedRequests: try row.decode(
                            column: "authenticated_requests",
                            as: Int?.self
                        ),
                        notFoundRequests: try row.decode(
                            column: "not_found_requests",
                            as: Int?.self
                        ),
                        clientErrorRequests: try row.decode(
                            column: "client_error_requests",
                            as: Int?.self
                        ),
                        serverErrorRequests: try row.decode(
                            column: "server_error_requests",
                            as: Int?.self
                        ),
                        pageViews: try row.decode(
                            column: "page_views",
                            as: Int?.self
                        ),
                        searchRequests: try row.decode(
                            column: "search_requests",
                            as: Int?.self
                        ),
                        botRequests: try row.decode(
                            column: "bot_requests",
                            as: Int?.self
                        ),
                        aiRequests: try row.decode(
                            column: "ai_requests",
                            as: Int?.self
                        ),
                        humanRequests: try row.decode(
                            column: "human_requests",
                            as: Int?.self
                        ),
                        uniqueVisitors: try row.decode(
                            column: "unique_visitors",
                            as: Int?.self
                        ),
                        itemCount: try row.decode(
                            column: "item_count",
                            as: Int?.self
                        )
                    )
                }
        }
    }

    func decodeOverviewBreakdowns(
        source: String,
        from: Date,
        to: Date,
        columns: Set<String>,
        dashboardOnly: Bool,
        notFoundOnly: Bool = false
    ) async throws -> [OverviewSummaryRow] {
        let fromTimestamp = from.timeIntervalSince1970
        let toTimestamp = to.timeIntervalSince1970
        let responseCodeSQL = overviewOptionalColumnSQL(
            "response_code",
            columns: columns,
            fallback: "NULL::integer"
        )
        let methodSQL = overviewOptionalColumnSQL(
            "method",
            columns: columns,
            fallback: "NULL::text"
        )
        let trafficTypeSQL =
            notFoundOnly
            ? "'human'::text"
            : overviewTrafficCategorySQL(source: source, columns: columns)
        let baseWhereSQL = overviewWhereSQL(
            source: source,
            columns: columns
        )
        let whereSQL =
            notFoundOnly
            ? "(\(baseWhereSQL)) AND response_code = 404"
            : baseWhereSQL

        var dimensions: [OverviewBreakdownDimension] = []
        var baseSelectSQL: [String] = [
            "\(responseCodeSQL) AS response_code",
            "\(methodSQL) AS method",
        ]
        if columns.contains("path") {
            baseSelectSQL.append(
                "COALESCE(NULLIF(path, ''), 'Unknown') AS path_label"
            )
            dimensions.append(
                .init(category: "paths", column: "path_label")
            )
        }
        if source == "web_app",
            !notFoundOnly,
            !dashboardOnly,
            columns.contains("response_code")
        {
            baseSelectSQL.append(
                """
                CASE
                    WHEN response_code BETWEEN 200 AND 299 THEN '2xx'
                    WHEN response_code BETWEEN 300 AND 399 THEN '3xx'
                    WHEN response_code BETWEEN 400 AND 499 THEN '4xx'
                    ELSE '5xx'
                END AS status_family
                """
            )
            dimensions.append(
                .init(category: "statusFamilies", column: "status_family")
            )
        }
        if !notFoundOnly, !dashboardOnly, columns.contains("method") {
            baseSelectSQL.append(
                "COALESCE(NULLIF(method, ''), 'Unknown') AS method_label"
            )
            dimensions.append(
                .init(category: "methods", column: "method_label")
            )
        }

        let textDimensions: [(String, String, String, Bool)] = [
            ("referer", "referrers", "referer_label", true),
            ("browser_name", "browsers", "browser_label", true),
            ("os_name", "operatingSystems", "os_label", true),
            ("device_type", "deviceTypes", "device_label", true),
            ("language", "languages", "language_label", true),
            ("region", "regions", "region_label", true),
        ]
        for (column, category, alias, enabled) in textDimensions
        where !notFoundOnly
            && source == "web_app"
            && enabled
            && columns.contains(column)
        {
            let labelSQL =
                column == "referer"
                ? "COALESCE(NULLIF(referer, ''), '(Direct)')"
                : "COALESCE(NULLIF(\(column), ''), 'Unknown')"
            baseSelectSQL.append("\(labelSQL) AS \(alias)")
            dimensions.append(.init(category: category, column: alias))
        }

        guard !dimensions.isEmpty else { return [] }
        let categoryCaseSQL =
            dimensions
            .map {
                "WHEN GROUPING(\($0.column)) = 0 THEN '\($0.category)'"
            }
            .joined(separator: "\n                    ")
        let labelCaseSQL =
            dimensions
            .map {
                "WHEN GROUPING(\($0.column)) = 0 THEN \($0.column)"
            }
            .joined(separator: "\n                    ")
        let groupingSetsSQL =
            dimensions
            .map { "(\($0.column))" }
            .joined(separator: ", ")
        let baseSelectListSQL = baseSelectSQL.joined(
            separator: ",\n                    "
        )
        let audiencePredicateSQL: String
        if source == "web_app",
            columns.isSuperset(of: ["method", "response_code"])
        {
            audiencePredicateSQL =
                "method = 'GET' AND response_code BETWEEN 200 AND 299 AND traffic_type = 'human'"
        }
        else {
            audiencePredicateSQL = source == "web_app" ? "FALSE" : "TRUE"
        }
        let webSourceSQL = source == "web_app" ? "TRUE" : "FALSE"
        let pathBreakdownsSQL: String
        if columns.contains("path") {
            let pathCountSQL =
                source == "web_app" ? "page_view_count" : "total_count"
            let errorBreakdownsSQL =
                dashboardOnly
                ? ""
                : """
                UNION ALL
                SELECT
                    'notFoundPaths'::text,
                    label,
                    not_found_count
                FROM grouped
                WHERE category = 'paths'

                UNION ALL

                SELECT
                    'serverErrorPaths'::text,
                    label,
                    server_error_count
                FROM grouped
                WHERE category = 'paths'
                """
            pathBreakdownsSQL = """
                UNION ALL
                SELECT
                    'paths'::text,
                    label,
                    \(pathCountSQL)
                FROM grouped
                WHERE category = 'paths'
                \(errorBreakdownsSQL)
                """
        }
        else {
            pathBreakdownsSQL = ""
        }

        let query: DatabaseQuery = #"""
            WITH base AS (
                SELECT
                    \#(unescaped: baseSelectListSQL),
                    \#(unescaped: trafficTypeSQL) AS traffic_type
                FROM analytics_log
                WHERE created_at >= TO_TIMESTAMP(\#(fromTimestamp))
                    AND created_at < TO_TIMESTAMP(\#(toTimestamp))
                    AND source = \#(source)
                    AND \#(unescaped: whereSQL)
            ),
            filtered AS (
                SELECT
                    base.*,
                    (\#(unescaped: audiencePredicateSQL)) AS is_audience_view
                FROM base
            ),
            grouped AS (
                SELECT
                    CASE
                        \#(unescaped: categoryCaseSQL)
                        ELSE 'unknown'
                    END AS category,
                    CASE
                        \#(unescaped: labelCaseSQL)
                        ELSE 'Unknown'
                    END AS label,
                    COUNT(*) AS total_count,
                    COUNT(*) FILTER (
                        WHERE is_audience_view
                    ) AS page_view_count,
                    COUNT(*) FILTER (
                        WHERE response_code = 404
                    ) AS not_found_count,
                    COUNT(*) FILTER (
                        WHERE response_code >= 500
                    ) AS server_error_count
                FROM filtered
                GROUP BY GROUPING SETS (\#(unescaped: groupingSetsSQL))
            ),
            expanded AS (
                SELECT
                    category,
                    label,
                    CASE
                        WHEN category = 'paths' THEN
                            CASE WHEN \#(unescaped: webSourceSQL)
                                THEN page_view_count
                                ELSE total_count
                            END
                        WHEN category IN (
                            'referrers',
                            'browsers',
                            'operatingSystems',
                            'deviceTypes',
                            'languages',
                            'regions'
                        ) THEN page_view_count
                        ELSE total_count
                    END AS item_count
                FROM grouped
                WHERE category <> 'paths'
                \#(unescaped: pathBreakdownsSQL)
            ),
            ranked AS (
                SELECT
                    category,
                    label,
                    item_count,
                    ROW_NUMBER() OVER (
                        PARTITION BY category
                        ORDER BY item_count DESC, label ASC
                    ) AS category_rank
                FROM expanded
                WHERE item_count > 0
            )
            SELECT
                'breakdown'::text AS row_type,
                category,
                label,
                NULL::double precision AS bucket,
                NULL::bigint AS total_requests,
                NULL::bigint AS requests,
                NULL::bigint AS authenticated_requests,
                NULL::bigint AS not_found_requests,
                NULL::bigint AS client_error_requests,
                NULL::bigint AS server_error_requests,
                NULL::bigint AS page_views,
                NULL::bigint AS search_requests,
                NULL::bigint AS bot_requests,
                NULL::bigint AS ai_requests,
                NULL::bigint AS human_requests,
                NULL::bigint AS unique_visitors,
                item_count
            FROM ranked
            WHERE category_rank <=
                CASE WHEN category = 'statusFamilies' THEN 5 ELSE 10 END
            ORDER BY category, category_rank;
            """#
        return try await context.connection.run(query: query) { sequence in
            try await sequence.collect()
                .map { row in
                    OverviewSummaryRow(
                        rowType: try row.decode(
                            column: "row_type",
                            as: String.self
                        ),
                        category: try row.decode(
                            column: "category",
                            as: String.self
                        ),
                        label: try row.decode(
                            column: "label",
                            as: String?.self
                        ),
                        bucket: try row.decode(
                            column: "bucket",
                            as: Double?.self
                        ),
                        totalRequests: try row.decode(
                            column: "total_requests",
                            as: Int?.self
                        ),
                        requests: try row.decode(
                            column: "requests",
                            as: Int?.self
                        ),
                        authenticatedRequests: try row.decode(
                            column: "authenticated_requests",
                            as: Int?.self
                        ),
                        notFoundRequests: try row.decode(
                            column: "not_found_requests",
                            as: Int?.self
                        ),
                        clientErrorRequests: try row.decode(
                            column: "client_error_requests",
                            as: Int?.self
                        ),
                        serverErrorRequests: try row.decode(
                            column: "server_error_requests",
                            as: Int?.self
                        ),
                        pageViews: try row.decode(
                            column: "page_views",
                            as: Int?.self
                        ),
                        searchRequests: try row.decode(
                            column: "search_requests",
                            as: Int?.self
                        ),
                        botRequests: try row.decode(
                            column: "bot_requests",
                            as: Int?.self
                        ),
                        aiRequests: try row.decode(
                            column: "ai_requests",
                            as: Int?.self
                        ),
                        humanRequests: try row.decode(
                            column: "human_requests",
                            as: Int?.self
                        ),
                        uniqueVisitors: try row.decode(
                            column: "unique_visitors",
                            as: Int?.self
                        ),
                        itemCount: try row.decode(
                            column: "item_count",
                            as: Int?.self
                        )
                    )
                }
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
        let botPredicateSQL = overviewBotPredicateSQL(columns: columns)
        let aiPredicateSQL = overviewAIPredicateSQL(columns: columns)
        let otherBotPredicateSQL = overviewOtherBotPredicateSQL(
            columns: columns
        )
        let humanPredicateSQL = overviewHumanPredicateSQL(columns: columns)
        let pageViewsSQL =
            source == "web_app"
                && columns.isSuperset(of: ["method", "response_code"])
            ? "COUNT(*) FILTER (WHERE method = 'GET' AND response_code BETWEEN 200 AND 299 AND NOT ((\(botPredicateSQL)) OR (\(aiPredicateSQL)))) AS page_views"
            : "0 AS page_views"
        let searchRequestsSQL =
            source == "web_app"
                && columns.isSuperset(of: ["method", "path"])
            ? "COUNT(*) FILTER (WHERE method = 'POST' AND LOWER(TRIM(BOTH '/' FROM path)) = 'search') AS search_requests"
            : "0 AS search_requests"
        let botRequestsSQL =
            source == "web_app" && columns.contains("traffic_category")
            ? "COUNT(*) FILTER (WHERE \(otherBotPredicateSQL)) AS bot_requests"
            : "0 AS bot_requests"
        let aiRequestsSQL =
            source == "web_app" && columns.contains("traffic_category")
            ? "COUNT(*) FILTER (WHERE \(aiPredicateSQL)) AS ai_requests"
            : "0 AS ai_requests"
        let humanRequestsSQL =
            source == "web_app"
            ? "COUNT(*) FILTER (WHERE \(humanPredicateSQL)) AS human_requests"
            : "0 AS human_requests"
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
                    \#(unescaped: serverErrorRequestsSQL),
                    \#(unescaped: pageViewsSQL),
                    \#(unescaped: searchRequestsSQL),
                    \#(unescaped: botRequestsSQL),
                    \#(unescaped: aiRequestsSQL),
                    \#(unescaped: humanRequestsSQL)
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
                    \#(unescaped: serverErrorRequestsSQL),
                    \#(unescaped: pageViewsSQL),
                    \#(unescaped: searchRequestsSQL),
                    \#(unescaped: botRequestsSQL),
                    \#(unescaped: aiRequestsSQL),
                    \#(unescaped: humanRequestsSQL)
                FROM analytics_log
                WHERE created_at >= TO_TIMESTAMP(\#(fromTimestamp))
                    AND created_at < TO_TIMESTAMP(\#(toTimestamp))
                    AND \#(unescaped: whereSQL);
                """#
        }
        return try await context.connection.run(query: query) { sequence in
            guard let row = try await sequence.collect().first else {
                return OverviewKPIRow(
                    totalRequests: 0,
                    authenticatedRequests: 0,
                    notFoundRequests: 0,
                    clientErrorRequests: 0,
                    serverErrorRequests: 0,
                    pageViews: 0,
                    searchRequests: 0,
                    botRequests: 0,
                    aiRequests: 0,
                    humanRequests: 0
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
                ),
                pageViews: try row.decode(column: "page_views", as: Int.self),
                searchRequests: try row.decode(
                    column: "search_requests",
                    as: Int.self
                ),
                botRequests: try row.decode(
                    column: "bot_requests",
                    as: Int.self
                ),
                aiRequests: try row.decode(column: "ai_requests", as: Int.self),
                humanRequests: try row.decode(
                    column: "human_requests",
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
        let botPredicateSQL = overviewBotPredicateSQL(columns: columns)
        let requestsSQL: String
        if source == "web_app",
            columns.isSuperset(of: ["method", "response_code"])
        {
            requestsSQL =
                "COUNT(log.id) FILTER (WHERE log.method = 'GET' AND log.response_code BETWEEN 200 AND 299 AND NOT (\(botPredicateSQL.replacingOccurrences(of: "traffic_category", with: "log.traffic_category")))) AS requests"
        }
        else {
            requestsSQL = "COUNT(log.id) AS requests"
        }
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
                    \#(unescaped: requestsSQL),
                    \#(unescaped: notFoundRequestsSQL),
                    \#(unescaped: clientErrorRequestsSQL),
                    \#(unescaped: serverErrorRequestsSQL)
                FROM buckets
                LEFT JOIN analytics_log AS log
                    ON log.created_at >= bucket
                    AND log.created_at < bucket + interval '1 day'
                    AND log.created_at >= GREATEST(
                        bucket,
                        TO_TIMESTAMP(\#(fromTimestamp))
                    )
                    AND log.created_at < LEAST(
                        bucket + interval '1 day',
                        TO_TIMESTAMP(\#(toTimestamp))
                    )
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
                    \#(unescaped: requestsSQL),
                    \#(unescaped: notFoundRequestsSQL),
                    \#(unescaped: clientErrorRequestsSQL),
                    \#(unescaped: serverErrorRequestsSQL)
                FROM buckets
                LEFT JOIN analytics_log AS log
                    ON log.created_at >= bucket
                    AND log.created_at < bucket + interval '1 day'
                    AND log.created_at >= GREATEST(
                        bucket,
                        TO_TIMESTAMP(\#(fromTimestamp))
                    )
                    AND log.created_at < LEAST(
                        bucket + interval '1 day',
                        TO_TIMESTAMP(\#(toTimestamp))
                    )
                    AND \#(unescaped: joinWhereSQL)
                GROUP BY bucket
                ORDER BY bucket ASC;
                """#
        }
        return try await context.connection.run(query: query) { sequence in
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
        enabled: Bool = true,
        source: String,
        from: Date,
        to: Date,
        columns: Set<String>,
        requiredColumns: [String] = [],
        labelSQL: String,
        whereSQL: String = "TRUE",
        limit: Int = 10
    ) async throws -> [OverviewBreakdownRow] {
        guard enabled, requiredColumns.allSatisfy(columns.contains) else {
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
        return try await context.connection.run(query: query) { sequence in
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
    ) -> [Log.Overview.Output.BreakdownItem] {
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
        let systemPaths = """
            \(pathExpression) NOT LIKE '/admin/%'
            AND \(pathExpression) NOT LIKE '/.well-known/%'
            AND \(pathExpression) <> '/favicon.ico'
            """
        return systemPaths
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
        query: Log.Overview.Input.Query
    ) async throws -> Log.Overview.Output {
        let from = overviewDate(query.from)
        let to = overviewDate(query.to)
        let columns = try await analyticsLogColumns()
        let summaryRows = try await decodeOverviewSummary(
            source: query.source,
            from: from,
            to: to,
            columns: columns,
            dashboardOnly: query.dashboardOnly,
            notFoundOnly: query.notFoundOnly
        )
        let breakdownRows = try await decodeOverviewBreakdowns(
            source: query.source,
            from: from,
            to: to,
            columns: columns,
            dashboardOnly: query.dashboardOnly,
            notFoundOnly: query.notFoundOnly
        )
        let totalRow = summaryRows.first {
            $0.rowType == "summary" && $0.category == "total"
        }
        let total = totalRow?.totalRequests ?? 0
        let pageViews = totalRow?.pageViews ?? 0
        let audienceTotal = query.source == "web_app" ? pageViews : total
        let averageRequestsPerDay =
            Double(total)
            / overviewDays(
                from: from,
                to: to
            )
        let daily =
            summaryRows
            .filter { $0.rowType == "summary" && $0.category == "daily" }
            .compactMap { row -> Log.Overview.Output.DailyPoint? in
                guard let bucket = row.bucket else { return nil }
                return .init(
                    bucket: bucket,
                    requests: row.requests ?? 0,
                    notFoundRequests: row.notFoundRequests ?? 0,
                    clientErrorRequests: row.clientErrorRequests ?? 0,
                    serverErrorRequests: row.serverErrorRequests ?? 0
                )
            }
            .sorted { $0.bucket < $1.bucket }
        let breakdowns = Dictionary(
            grouping: breakdownRows.filter { $0.rowType == "breakdown" },
            by: \.category
        )
        func mappedBreakdown(
            _ category: String,
            total: Int
        ) -> [Log.Overview.Output.BreakdownItem] {
            let rows = breakdowns[category, default: []]
                .compactMap {
                    row -> OverviewBreakdownRow? in
                    guard let label = row.label, let count = row.itemCount
                    else {
                        return nil
                    }
                    return .init(label: label, count: count)
                }
            return mapOverviewBreakdown(
                rows,
                total: total
            )
        }

        return .init(
            kpis: .init(
                totalRequests: total,
                averageRequestsPerDay: averageRequestsPerDay,
                authenticatedRequests: totalRow?.authenticatedRequests ?? 0,
                notFoundRequests: totalRow?.notFoundRequests ?? 0,
                clientErrorRequests: totalRow?.clientErrorRequests ?? 0,
                serverErrorRequests: totalRow?.serverErrorRequests ?? 0,
                pageViews: pageViews,
                searchRequests: totalRow?.searchRequests ?? 0,
                botRequests: totalRow?.botRequests ?? 0,
                aiRequests: totalRow?.aiRequests ?? 0,
                humanRequests: totalRow?.humanRequests ?? 0,
                uniqueVisitors: totalRow?.uniqueVisitors ?? 0
            ),
            daily: daily,
            statusFamilies: mappedBreakdown("statusFamilies", total: total),
            methods: mappedBreakdown("methods", total: total),
            paths: mappedBreakdown("paths", total: audienceTotal),
            notFoundPaths: mappedBreakdown("notFoundPaths", total: total),
            serverErrorPaths: mappedBreakdown(
                "serverErrorPaths",
                total: total
            ),
            referrers: mappedBreakdown("referrers", total: audienceTotal),
            browsers: mappedBreakdown("browsers", total: audienceTotal),
            operatingSystems: mappedBreakdown(
                "operatingSystems",
                total: audienceTotal
            ),
            deviceTypes: mappedBreakdown("deviceTypes", total: audienceTotal),
            languages: mappedBreakdown("languages", total: audienceTotal),
            regions: mappedBreakdown("regions", total: audienceTotal)
        )
    }

    public func find(
        id: String
    ) async throws -> Log.Detail.Output {
        let table = LogTable(connection: context.connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDomain.asDetail
    }
}
