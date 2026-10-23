public import FeatherApplication
public import FeatherModuleKit
import Foundation
import NewsModule
import WebApplication
import WebDomain

extension Public.Article.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Public.Article.Detail.Scope>

        public init(
            query: any QueryExecutor<Public.Article.Detail.Scope>
        ) {
            self.query = query
        }

        public func execute(
            input: Input
        ) async throws -> Public.Article.Detail.Output {
            let now = Date()
            return try await query.run { scope in
                let article = try await scope.article.find(id: input.id)
                guard article.metadata.isDirectlyAccessible(at: now) else {
                    throw Error(message: "Article not found")
                }
                let categories = try await scope.category
                    .findCategories(ids: article.categoryIds)
                    .items
                    .filter { $0.metadata.isPublic(at: now) }
                    .map {
                        Public.Category.Summary.Item(
                            id: $0.id,
                            title: $0.title,
                            excerpt: $0.excerpt,
                            imageAssetId: $0.imageAssetId,
                            imageURL: "",
                            media: nil,
                            metadata: $0.metadata
                        )
                    }

                return .init(
                    id: article.id,
                    title: article.title,
                    excerpt: article.excerpt,
                    content: article.content,
                    imageAssetId: article.imageAssetId,
                    imageURL: "",
                    media: nil,
                    metadata: article.metadata,
                    categories: categories
                )
            }
        }
    }
}
