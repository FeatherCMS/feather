public import FeatherApplication
public import FeatherModuleKit
import Foundation
import NewsModule
import WebApplication

extension Public.Article.Search {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Scope>

        public init(query: any QueryExecutor<Scope>) {
            self.query = query
        }

        public func execute(input: Input) async throws -> Output {
            let rawSearch = input.query.search?
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
            let search = rawSearch?.isEmpty == false ? rawSearch : nil
            let pageSize = max(1, input.query.pageSize)
            let now = Date()

            return try await query.run { scope in
                let total = try await scope.article.countPublic(
                    search: search
                )
                let pageCount = max(1, (total + pageSize - 1) / pageSize)
                let page = min(max(1, input.query.pageNumber), pageCount)
                let articles = try await scope.article.searchPublic(
                    query: .init(
                        search: search,
                        pageNumber: page,
                        pageSize: pageSize
                    )
                )
                let metadataByID = Dictionary(
                    uniqueKeysWithValues: try await scope.metadataDetails
                        .resolveDetails(
                            referenceType: "news.article",
                            referenceIDs: Array(Set(articles.items.map(\.id)))
                        )
                        .filter { $0.isPublic(at: now) }
                        .map { ($0.referenceID, $0) }
                )
                let publicArticles = articles.items.filter {
                    metadataByID[$0.id] != nil
                }
                let categoryIDsByArticleID = try await scope.articleCategoryIDs
                    .categoryIDs(for: publicArticles.map(\.id))

                let items: [Public.Article.Summary.Item] =
                    publicArticles
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
                            categoryIDs: categoryIDsByArticleID[article.id]
                                ?? []
                        )
                    }
                return .init(
                    items: items,
                    total: total,
                    page: page,
                    pageSize: pageSize
                )
            }
        }
    }
}
