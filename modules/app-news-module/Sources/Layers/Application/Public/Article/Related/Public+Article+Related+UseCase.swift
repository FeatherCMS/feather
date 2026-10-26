public import FeatherApplication
public import FeatherModuleKit
import Foundation
import NewsModule
import WebApplication
import WebModule

extension Public.Article.Related {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Scope>

        public init(query: any QueryExecutor<Scope>) {
            self.query = query
        }

        public func execute(input: Input) async throws -> Output {
            let categoryIDs = Array(Set(input.categoryIDs)).filter {
                !$0.isEmpty
            }
            guard !categoryIDs.isEmpty, input.limit > 0 else {
                return .init(items: [])
            }

            let now = Date()
            return try await query.run { scope in
                let articles = try await scope.relatedArticles.listPublicRelated(
                    categoryIDs: categoryIDs,
                    excludingArticleID: input.excludingArticleID,
                    limit: input.limit
                )
                let metadata = try await scope.metadataDetails.resolveDetails(
                    referenceType: "news.article",
                    referenceIDs: Array(Set(articles.items.map(\.id)))
                )
                var metadataByID: [String: WebModule.Metadata.Snapshot] = [:]
                for item in metadata where item.isPublic(at: now) {
                    precondition(
                        metadataByID.updateValue(
                            item,
                            forKey: item.referenceID
                        ) == nil
                    )
                }
                let categoryIDsByArticleID = try await scope.articleCategoryIDs
                    .categoryIDs(for: articles.items.map(\.id))

                let items: [Public.Article.Summary.Item] = articles.items
                    .compactMap { article -> Public.Article.Summary.Item? in
                    guard let metadata = metadataByID[article.id] else {
                        return nil
                    }
                    return Public.Article.Summary.Item(
                        id: article.id,
                        title: article.title,
                        excerpt: article.excerpt,
                        imageAssetId: article.imageAssetId,
                        imageURL: "",
                        media: nil,
                        metadata: metadata,
                        readingTime: Public.Article.ReadingTime.minutes(
                            for: article.content
                        ),
                        categoryIDs: categoryIDsByArticleID[article.id] ?? []
                    )
                    }
                return .init(items: items)
            }
        }
    }
}
