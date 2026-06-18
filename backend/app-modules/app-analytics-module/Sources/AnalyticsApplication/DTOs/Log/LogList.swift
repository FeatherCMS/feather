import Application

public struct LogList: DTO {

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

        package init(
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

    public struct Query: Sendable {

        public struct Sort: Sendable {
            public enum Field: String, Sendable, CaseIterable {
                case id
                case accountId
                case method
                case source
                case path
                case responseCode
                case ip
                case browserName
                case createdAt
            }

            public let field: Field
            public let direction: Search.SortDirection

            public init(
                field: Field,
                direction: Search.SortDirection
            ) {
                self.field = field
                self.direction = direction
            }
        }

        public let page: Search.Page
        public let sort: [Sort]
        public let search: String?
        public let source: String?
        public let method: String?
        public let responseCode: Int?

        public init(
            page: Search.Page = .init(),
            sort: [Sort] = [],
            search: String? = nil,
            source: String? = nil,
            method: String? = nil,
            responseCode: Int? = nil
        ) {
            self.page = page
            self.sort = sort
            self.search = search
            self.source = source
            self.method = method
            self.responseCode = responseCode
        }
    }

    public let items: [Item]

    public init(items: [Item]) {
        self.items = items
    }
}
