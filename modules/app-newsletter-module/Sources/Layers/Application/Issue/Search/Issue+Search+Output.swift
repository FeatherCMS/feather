public import FeatherApplication
public import NewsletterDomain
public import NewsletterModule

public import struct Foundation.Date

extension Issue.Search {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let subject: String
            public let status: Issue.Model.Status
            public let scheduledDate: Date?
            public let createdAt: Date

            package init(
                id: String,
                subject: String,
                status: Issue.Model.Status,
                scheduledDate: Date?,
                createdAt: Date
            ) {
                self.id = id
                self.subject = subject
                self.status = status
                self.scheduledDate = scheduledDate
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
