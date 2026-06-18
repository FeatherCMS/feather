import Application

public struct MediaProcessorList: DTO {
    public struct Item: Sendable {
        public let id: String
        public let name: String
        public let matchExtensions: String
        public let commandTemplate: String
        public let isRequired: Bool
        public let isActive: Bool

        public init(
            id: String,
            name: String,
            matchExtensions: String,
            commandTemplate: String,
            isRequired: Bool,
            isActive: Bool
        ) {
            self.id = id
            self.name = name
            self.matchExtensions = matchExtensions
            self.commandTemplate = commandTemplate
            self.isRequired = isRequired
            self.isActive = isActive
        }
    }

    public struct Query: Sendable {
        public struct Sort: Sendable {
            public enum Field: String, Sendable, CaseIterable {
                case id
                case name
                case matchExtensions
                case commandTemplate
                case isRequired
                case isActive
                case createdAt
                case updatedAt
            }

            public var field: Field
            public var direction: Search.SortDirection

            public init(field: Field, direction: Search.SortDirection) {
                self.field = field
                self.direction = direction
            }
        }

        public var page: Search.Page
        public var sort: [Sort]
        public var search: String?

        public init(
            page: Search.Page = .init(),
            sort: [Sort] = [],
            search: String? = nil
        ) {
            self.page = page
            self.sort = sort
            self.search = search
        }
    }

    public let items: [Item]

    public init(items: [Item]) {
        self.items = items
    }
}
