public import FeatherApplication
public import NewsletterModule

extension Subscriber.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case email
                    case name
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

            public let page: FeatherApplication.Search.Page
            public let sort: [Sort]
            public let search: String?
            public let campaignKey: String?
            public let email: String?

            public init(
                page: FeatherApplication.Search.Page = .init(),
                sort: [Sort] = [],
                search: String? = nil,
                campaignKey: String? = nil,
                email: String? = nil
            ) {
                self.page = page
                self.sort = sort
                self.search = search
                self.campaignKey = campaignKey
                self.email = email
            }
        }

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
