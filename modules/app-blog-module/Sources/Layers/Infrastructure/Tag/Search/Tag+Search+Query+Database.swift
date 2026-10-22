public import BlogApplication
public import BlogModule
public import FeatherInfrastructure
public import WebApplication
public import WebModule

extension Tag.Search.Query {
    public struct Database: Interface {
        let context: DatabaseQueryContext
        let metadata: any WebModule.Metadata.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any WebModule.Metadata.Query.Interface
        ) {
            self.context = context
            self.metadata = metadata
        }

        public func search(
            query: Tag.Search.Input.Query
        ) async throws -> Tag.Search.Output {
            let database = BlogApplication.Public.Query.TagContent.Database(
                context: context,
                metadata: metadata
            )
            async let list = database.list(query: query)
            async let total = database.count(query: query)
            let (listResult, totalResult) = try await (list, total)
            let items = listResult.items.map {
                Tag.Search.Output.Item(
                    id: $0.id,
                    title: $0.title,
                    excerpt: $0.excerpt,
                    imageAssetId: $0.imageAssetId,
                    createdAt: $0.createdAt,
                    updatedAt: $0.updatedAt
                )
            }
            return .init(items: items, total: totalResult)
        }
    }
}
