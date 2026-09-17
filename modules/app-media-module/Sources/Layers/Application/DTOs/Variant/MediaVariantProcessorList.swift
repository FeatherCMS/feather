import FeatherApplication
import FeatherContracts

public struct MediaVariantProcessorList: DTO {
    public struct Item: Sendable {
        public let id: String
        public let variantId: String
        public let name: String
        public let matchExtensions: String
        public let commandTemplate: String
        public let isActive: Bool

        public init(id: String, variantId: String, name: String, matchExtensions: String, commandTemplate: String, isActive: Bool) {
            self.id = id
            self.variantId = variantId
            self.name = name
            self.matchExtensions = matchExtensions
            self.commandTemplate = commandTemplate
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
