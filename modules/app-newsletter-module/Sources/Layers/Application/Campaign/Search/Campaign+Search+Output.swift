public import FeatherApplication
public import NewsletterModule

extension Campaign.Search {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let key: String
            public let name: String
            public let fromEmail: String

            public init(
                id: String,
                key: String,
                name: String,
                fromEmail: String
            ) {
                self.id = id
                self.key = key
                self.name = name
                self.fromEmail = fromEmail
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
