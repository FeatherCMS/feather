public import BlogApplication
public import BlogModule
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension Post.Search.Query {
    public struct Database: Interface {
        let context: DatabaseQueryContext
        let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.context = context
            self.metadata = metadata
        }

        public func search(
            query: Post.Search.Input.Query
        ) async throws -> Post.Search.Output {
            let database = BlogApplication.Public.Post.Database(
                context: context,
                metadata: metadata
            )
            async let list = database.list(query: query)
            async let total = database.count(query: query)
            let (listResult, totalResult) = try await (list, total)
            let items = listResult.items.map { item in
                Post.Search.Output.Item(
                    id: item.id,
                    title: item.title,
                    excerpt: item.excerpt,
                    imageAssetId: item.imageAssetId,
                    createdAt: item.createdAt,
                    updatedAt: item.updatedAt
                )
            }
            return .init(items: items, total: totalResult)
        }
    }
}
