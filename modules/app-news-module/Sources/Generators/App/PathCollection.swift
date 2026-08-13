import FeatherOpenAPI
import NewsSharedOpenAPIGenerator
import OpenAPIKitCore

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        [
            "api/v1/news/articles": NewsArticleListPathItems(),
            "api/v1/news/articles/{id}": NewsArticleGetPathItems(),
            "api/v1/news/categories": NewsCategoryListPathItems(),
            "api/v1/news/categories/{id}": NewsCategoryGetPathItems(),
        ]
    }
}
