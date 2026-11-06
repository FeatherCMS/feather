public import FeatherApplication
public import FeatherModuleKit
import Foundation
import NewsModule
import WebApplication
import WebModule

extension Public.Article.Resolve {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Scope>

        public init(query: any QueryExecutor<Scope>) {
            self.query = query
        }

        public func execute(input: Input) async throws -> Output {
            var seenIDs = Set<String>()
            let ids = input.ids.filter { seenIDs.insert($0).inserted }
            guard !ids.isEmpty else { return .init(items: []) }

            let now = Date()
            return try await query.run { scope in
                let articles = try await scope.article.resolve(ids: ids)
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
                return .init(items: items)
            }
        }
    }
}
