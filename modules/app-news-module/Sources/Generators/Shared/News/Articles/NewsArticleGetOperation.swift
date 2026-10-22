import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsArticleGetOperation: NewsArticleOperation {
    var parameters: [any ParameterRepresentable] {
        [NewsArticleIdParameter().reference()]
    }

    var responseMap: ResponseMap {
        [
            200: NewsArticleDetailResponse().reference(),
            404: CustomResponse(description: "News item not found"),
        ]
    }
}
