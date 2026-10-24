public import BlogApplication
public import BlogModule
import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension BlogApplication.Public.Author {
    public struct Database: Detail.Query.Interface, List.Query.Interface {
        public let context: DatabaseQueryContext
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.context = context
            self.metadata = metadata
        }

        public func find(id: String) async throws
            -> BlogApplication.Public.Author.Detail.Query.Output
        {
            let author = try await Author.Detail.Query
                .Database(
                    context: context,
                    metadata: metadata
                )
                .find(id: id)
            return .init(
                id: author.id,
                name: author.name,
                excerpt: author.excerpt,
                content: author.content,
                profileImageAssetId: author.profileImageAssetId
            )
        }

        public func findAuthor(id: String) async throws -> List.Query.Author {
            let author = try await Author.Detail.Query.Database(
                context: context,
                metadata: metadata
            )
            .find(id: id)
            return .init(
                id: author.id,
                name: author.name,
                excerpt: author.excerpt,
                content: author.content,
                profileImageAssetId: author.profileImageAssetId
            )
        }

        public func list() async throws -> Author.List.Output {
            try await Author.List.Query.Database(context: context).list()
        }

        public func list(query: Author.Search.Input.Query) async throws
            -> BlogApplication.Public.Author.List.Query.Output
        {
            let result = try await Author.Search.Query.Database(context: context)
                .search(query: query)
            return .init(items: result.items.map { .init(id: $0.id) })
        }
    }
}
