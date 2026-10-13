import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        [
            "api/v1/admin/news/articles": NewsArticleCollectionPathItems(),
            "api/v1/admin/news/articles/": NewsArticleListPathItems(),
            "api/v1/admin/news/articles/search": NewsArticleSearchPathItems(),
            "api/v1/admin/news/articles/{newsArticleId}":
                NewsArticleIDPathItems(),
            "api/v1/admin/news/categories": NewsCategoryCollectionPathItems(),
            "api/v1/admin/news/categories/": NewsCategoryListPathItems(),
            "api/v1/admin/news/categories/search":
                NewsCategorySearchPathItems(),
            "api/v1/admin/news/categories/{newsCategoryId}":
                NewsCategoryIDPathItems(),
        ]
    }
}
