public import AnalyticsModule
public import FeatherDBAL

public import struct Foundation.Date

extension Log {
    public struct Table: DatabaseTable {
        public static let name = "analytics_log"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let id = DatabaseTableColumn<String>(name: "id")
            public let accountId = DatabaseTableColumn<String?>(
                name: "account_id"
            )
            public let source = DatabaseTableColumn<String>(name: "source")
            public let method = DatabaseTableColumn<String>(name: "method")
            public let url = DatabaseTableColumn<String>(name: "url")
            public let headers = DatabaseTableColumn<String>(name: "headers")
            public let ip = DatabaseTableColumn<String?>(name: "ip")
            public let path = DatabaseTableColumn<String>(name: "path")
            public let referer = DatabaseTableColumn<String?>(name: "referer")
            public let origin = DatabaseTableColumn<String?>(name: "origin")
            public let acceptLanguage = DatabaseTableColumn<String?>(
                name: "accept_language"
            )
            public let userAgent = DatabaseTableColumn<String?>(
                name: "user_agent"
            )
            public let trafficCategory = DatabaseTableColumn<String>(
                name: "traffic_category"
            )
            public let language = DatabaseTableColumn<String?>(name: "language")
            public let region = DatabaseTableColumn<String?>(name: "region")
            public let osName = DatabaseTableColumn<String?>(name: "os_name")
            public let osVersion = DatabaseTableColumn<String?>(
                name: "os_version"
            )
            public let browserName = DatabaseTableColumn<String?>(
                name: "browser_name"
            )
            public let browserVersion = DatabaseTableColumn<String?>(
                name: "browser_version"
            )
            public let engineName = DatabaseTableColumn<String?>(
                name: "engine_name"
            )
            public let engineVersion = DatabaseTableColumn<String?>(
                name: "engine_version"
            )
            public let deviceVendor = DatabaseTableColumn<String?>(
                name: "device_vendor"
            )
            public let deviceType = DatabaseTableColumn<String?>(
                name: "device_type"
            )
            public let deviceModel = DatabaseTableColumn<String?>(
                name: "device_model"
            )
            public let cpu = DatabaseTableColumn<String?>(name: "cpu")
            public let responseCode = DatabaseTableColumn<Int>(
                name: "response_code"
            )
            public let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            public let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
