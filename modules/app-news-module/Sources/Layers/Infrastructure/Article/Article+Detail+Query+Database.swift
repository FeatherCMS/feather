import FeatherDBAL
public import FeatherInfrastructure
public import NewsApplication
import NewsDomain
public import NewsModule
public import WebApplication
import WebDomain
public import WebModule

extension Article.Table.Detail {
    func asDetail(
        metadata: WebModule.Metadata.Snapshot,
        categoryIds: [String]
    ) -> Article.Detail.Output {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            categoryIds: categoryIds,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Article.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.context = context
            self.metadata = metadata
        }

        public func find(id: String) async throws -> Article.Detail.Output {
            let accessLayer = DatabaseAccessLayer<Article.Table>(
                context: context
            )
            guard
                let row = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw RepositoryError.notFound
            }
            let categoryIds = try await ArticleCategory.Table.listCategoryIDs(
                context: context,
                articleID: id
            )
            guard
                let metadata = try await metadata.find(
                    referenceType: "news.article",
                    referenceID: id
                )
            else {
                throw RepositoryError.notFound
            }
            return row.asDetail(metadata: metadata, categoryIds: categoryIds)
        }
    }
}
