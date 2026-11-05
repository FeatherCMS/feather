public import BlogApplication
public import BlogModule
import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
public import WebModule

extension Tag.Detail.Query {
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

        public func find(id: String) async throws -> Tag.Detail.Output {
            guard
                let row = try await DatabaseAccessLayer<Tag.Table>(
                    context: context
                )
                .selectFirst(by: \.id, equals: id)
            else {
                throw RepositoryError.notFound
            }
            guard
                let metadata = try await metadata.find(
                    referenceType: "blog.tag",
                    referenceID: id
                )
            else {
                throw RepositoryError.notFound
            }
            return .init(
                id: row.id,
                title: row.title,
                excerpt: row.excerpt,
                content: row.content,
                imageAssetId: row.imageAssetId,
                metadata: metadata,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt
            )
        }
    }
}
