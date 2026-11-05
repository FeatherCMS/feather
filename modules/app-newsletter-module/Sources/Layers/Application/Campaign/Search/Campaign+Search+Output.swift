public import FeatherApplication
public import NewsletterModule

extension Campaign.Search {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let key: String
            public let name: String
            public let fromEmail: String
            public let subscriberCount: Int
            public let sentIssueCount: Int

            public init(
                id: String,
                key: String,
                name: String,
                fromEmail: String,
                subscriberCount: Int,
                sentIssueCount: Int
            ) {
                self.id = id
                self.key = key
                self.name = name
                self.fromEmail = fromEmail
                self.subscriberCount = subscriberCount
                self.sentIssueCount = sentIssueCount
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
