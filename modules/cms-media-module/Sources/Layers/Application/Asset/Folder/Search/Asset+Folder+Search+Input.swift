public import FeatherApplication
public import MediaModule

extension Asset.Folder.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case id
                    case name
                    case path
                    case assetCount
                    case totalSizeBytes
                    case createdAt
                    case updatedAt
                }

                public let field: Field
                public let direction: FeatherApplication.Search.SortDirection

                public init(field: Field, direction: Search.SortDirection) {
                    self.field = field
                    self.direction = direction
                }
            }

            public let page: FeatherApplication.Search.Page
            public let sort: [Sort]
            public let parentId: String?

            public init(
                page: FeatherApplication.Search.Page = .init(),
                sort: [Sort] = [],
                parentId: String? = nil
            ) {
                self.page = page
                self.sort = sort
                self.parentId = parentId
            }
        }

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
