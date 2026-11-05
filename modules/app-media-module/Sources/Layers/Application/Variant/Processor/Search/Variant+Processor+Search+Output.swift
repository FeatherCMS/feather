public import FeatherApplication
public import MediaModule

extension Variant.Processor.Search {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let variantId: String
            public let name: String
            public let matchExtensions: String
            public let commandTemplate: String
            public let isActive: Bool

            public init(
                id: String,
                variantId: String,
                name: String,
                matchExtensions: String,
                commandTemplate: String,
                isActive: Bool
            ) {
                self.id = id
                self.variantId = variantId
                self.name = name
                self.matchExtensions = matchExtensions
                self.commandTemplate = commandTemplate
                self.isActive = isActive
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
