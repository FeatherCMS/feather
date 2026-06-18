import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension LogTable.Row {

    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.accountId = try row.decode(column: "account_id", as: String?.self)
        self.source = try row.decode(column: "source", as: String.self)
        self.method = try row.decode(column: "method", as: String.self)
        self.url = try row.decode(column: "url", as: String.self)
        self.headers = try row.decode(column: "headers", as: String.self)
        self.ip = try row.decode(column: "ip", as: String?.self)
        self.path = try row.decode(column: "path", as: String.self)
        self.referer = try row.decode(column: "referer", as: String?.self)
        self.origin = try row.decode(column: "origin", as: String?.self)
        self.acceptLanguage = try row.decode(
            column: "accept_language",
            as: String?.self
        )
        self.userAgent = try row.decode(
            column: "user_agent",
            as: String?.self
        )
        self.language = try row.decode(column: "language", as: String?.self)
        self.region = try row.decode(column: "region", as: String?.self)
        self.osName = try row.decode(column: "os_name", as: String?.self)
        self.osVersion = try row.decode(
            column: "os_version",
            as: String?.self
        )
        self.browserName = try row.decode(
            column: "browser_name",
            as: String?.self
        )
        self.browserVersion = try row.decode(
            column: "browser_version",
            as: String?.self
        )
        self.engineName = try row.decode(
            column: "engine_name",
            as: String?.self
        )
        self.engineVersion = try row.decode(
            column: "engine_version",
            as: String?.self
        )
        self.deviceVendor = try row.decode(
            column: "device_vendor",
            as: String?.self
        )
        self.deviceType = try row.decode(
            column: "device_type",
            as: String?.self
        )
        self.deviceModel = try row.decode(
            column: "device_model",
            as: String?.self
        )
        self.cpu = try row.decode(column: "cpu", as: String?.self)
        self.responseCode = try row.decode(
            column: "response_code",
            as: Int.self
        )
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct LogTable {

    struct Row {

        struct Create {
            let id: String
            let accountId: String?
            let source: String
            let method: String
            let url: String
            let headers: String
            let ip: String?
            let path: String
            let referer: String?
            let origin: String?
            let acceptLanguage: String?
            let userAgent: String?
            let language: String?
            let region: String?
            let osName: String?
            let osVersion: String?
            let browserName: String?
            let browserVersion: String?
            let engineName: String?
            let engineVersion: String?
            let deviceVendor: String?
            let deviceType: String?
            let deviceModel: String?
            let cpu: String?
            let responseCode: Int
        }

        let id: String
        let accountId: String?
        let source: String
        let method: String
        let url: String
        let headers: String
        let ip: String?
        let path: String
        let referer: String?
        let origin: String?
        let acceptLanguage: String?
        let userAgent: String?
        let language: String?
        let region: String?
        let osName: String?
        let osVersion: String?
        let browserName: String?
        let browserVersion: String?
        let engineName: String?
        let engineVersion: String?
        let deviceVendor: String?
        let deviceType: String?
        let deviceModel: String?
        let cpu: String?
        let responseCode: Int
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func create(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO analytics_log (
                    id,
                    account_id,
                    source,
                    method,
                    url,
                    headers,
                    ip,
                    path,
                    referer,
                    origin,
                    accept_language,
                    user_agent,
                    language,
                    region,
                    os_name,
                    os_version,
                    browser_name,
                    browser_version,
                    engine_name,
                    engine_version,
                    device_vendor,
                    device_type,
                    device_model,
                    cpu,
                    response_code,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.accountId),
                    \#(row.source),
                    \#(row.method),
                    \#(row.url),
                    \#(row.headers),
                    \#(row.ip),
                    \#(row.path),
                    \#(row.referer),
                    \#(row.origin),
                    \#(row.acceptLanguage),
                    \#(row.userAgent),
                    \#(row.language),
                    \#(row.region),
                    \#(row.osName),
                    \#(row.osVersion),
                    \#(row.browserName),
                    \#(row.browserVersion),
                    \#(row.engineName),
                    \#(row.engineVersion),
                    \#(row.deviceVendor),
                    \#(row.deviceType),
                    \#(row.deviceModel),
                    \#(row.cpu),
                    \#(row.responseCode),
                    NOW(),
                    NOW()
                )
                RETURNING *;
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
                SELECT *
                FROM analytics_log
                WHERE id = \#(id)
                LIMIT 1;
                """#
        ) { sequence in
            try await sequence.collect().first.map { try Row(from: $0) }
        }
    }

    func list(
        search: String?,
        source: String?,
        method: String?,
        responseCode: Int?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM analytics_log
                WHERE (
                    \#(search == nil)
                    OR LOWER(path) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                )
                AND (
                    \#(source == nil)
                    OR source = \#(source ?? "")
                )
                AND (
                    \#(method == nil)
                    OR method = \#(method ?? "")
                )
                AND (
                    \#(responseCode == nil)
                    OR response_code = \#(responseCode ?? 0)
                )
                ORDER BY \#(unescaped: orderBy)
                LIMIT \#(limit)
                OFFSET \#(offset);
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func count(
        search: String?,
        source: String?,
        method: String?,
        responseCode: Int?
    ) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM analytics_log
                WHERE (
                    \#(search == nil)
                    OR LOWER(path) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                )
                AND (
                    \#(source == nil)
                    OR source = \#(source ?? "")
                )
                AND (
                    \#(method == nil)
                    OR method = \#(method ?? "")
                )
                AND (
                    \#(responseCode == nil)
                    OR response_code = \#(responseCode ?? 0)
                );
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return 0
            }
            return try row.decode(column: "count", as: Int.self)
        }
    }
}
