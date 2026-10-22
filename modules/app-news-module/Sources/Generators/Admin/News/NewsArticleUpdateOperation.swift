import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsArticleUpdateOperation: NewsArticleIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        NewsArticleUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: NewsArticleDetailResponse().reference(),
            404: CustomResponse(description: "News article not found"),
        ]
    }
}
