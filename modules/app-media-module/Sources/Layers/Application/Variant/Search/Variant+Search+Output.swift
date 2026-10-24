public import FeatherApplication
public import MediaModule

extension Variant.Search {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let key: String
            public let name: String
            public let isRequired: Bool
            public let isActive: Bool

            public init(
                id: String,
                key: String,
                name: String,
                isRequired: Bool,
                isActive: Bool
            ) {
                self.id = id
                self.key = key
                self.name = name
                self.isRequired = isRequired
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
