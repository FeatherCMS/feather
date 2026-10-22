import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsArticleListOperation: NewsArticleOperation {
    var responseMap: ResponseMap {
        [200: NewsArticleListResponse().reference()]
    }
}
