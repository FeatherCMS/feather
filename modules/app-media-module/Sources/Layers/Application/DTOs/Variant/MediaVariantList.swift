import FeatherApplication
import FeatherContracts

public struct MediaVariantList: DTO {
    public struct Item: Sendable {
        public let id: String
        public let key: String
        public let name: String
        public let isRequired: Bool
        public let isActive: Bool

        public init(id: String, key: String, name: String, isRequired: Bool, isActive: Bool) {
            self.id = id
            self.key = key
            self.name = name
            self.isRequired = isRequired
            self.isActive = isActive
        }
    }

    public struct Query: Sendable {
        public var page: Search.Page
        public var search: String?

        public init(page: Search.Page = .init(), search: String? = nil) {
            self.page = page
            self.search = search
        }
    }

    public let items: [Item]

    public init(items: [Item]) { self.items = items }
}
