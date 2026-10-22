import FeatherOpenAPIGenerator
import OpenAPIKit30
public import FeatherOpenAPI

struct NewsArticleListOperation: NewsArticleOperation {
    var responseMap: ResponseMap {
        [200: NewsArticleListResponse().reference()]
    }
}
