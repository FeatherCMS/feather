import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Article {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/news/articles": PathItem(),
                "api/v1/admin/news/articles/query": Query.PathItem(),
                "api/v1/admin/news/articles/{newsArticleId}": ID.PathItem(),
            ]
        }
    }
}
