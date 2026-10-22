import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsArticleGetOperation: NewsArticleIDOperation {
    var responseMap: ResponseMap {
        [
            200: NewsArticleDetailResponse().reference(),
            404: CustomResponse(description: "News article not found"),
        ]
    }
}
