import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsArticleCreateOperation: NewsArticleOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        NewsArticleRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: NewsArticleDetailResponse().reference()]
    }
}
