import AnalyticsDomain
public import AnalyticsModule
public import FeatherApplication

extension Log.Search {
    public struct Output: DTO, Sendable {
        public struct Item: Sendable {
            public let id: String
            public let accountId: String?
            public let source: String
            public let method: String
            public let path: String
            public let responseCode: Int
            public let ip: String?
            public let browserName: String?
            public let createdAt: Double

            public init(
                id: String,
                accountId: String?,
                source: String,
                method: String,
                path: String,
                responseCode: Int,
                ip: String?,
                browserName: String?,
                createdAt: Double
            ) {
                self.id = id
                self.accountId = accountId
                self.source = source
                self.method = method
                self.path = path
                self.responseCode = responseCode
                self.ip = ip
                self.browserName = browserName
                self.createdAt = createdAt
            }
        }

        public let items: [Item]
        public let total: Int

        public init(items: [Item], total: Int) {
            self.items = items
            self.total = total
        }
    }
}
