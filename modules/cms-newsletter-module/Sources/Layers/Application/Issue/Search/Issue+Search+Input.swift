public import FeatherApplication
public import NewsletterModule

extension Issue.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public let page: FeatherApplication.Search.Page
            public let sort: [Sort]
            public let search: String?

            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case subject
                    case status
                    case scheduledDate
                    case createdAt
                }

                public let field: Field
                public let direction: FeatherApplication.Search.SortDirection

                public init(
                    field: Field,
                    direction: FeatherApplication.Search.SortDirection
                ) {
                    self.field = field
                    self.direction = direction
                }
            }

            public init(
                page: FeatherApplication.Search.Page = .init(),
                sort: [Sort] = [],
                search: String? = nil
            ) {
                self.page = page
                self.sort = sort
                self.search = search
            }
        }

        public let campaignKey: String
        public let query: Query

        public init(campaignKey: String, query: Query) {
            self.campaignKey = campaignKey
            self.query = query
        }
    }
}
