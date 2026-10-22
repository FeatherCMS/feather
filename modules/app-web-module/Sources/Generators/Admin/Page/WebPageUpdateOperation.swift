import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct WebPageUpdateOperation: WebPageIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        WebPageUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebPageDetailResponse().reference(),
            404: CustomResponse(description: "WebPage not found"),
        ]
    }
}
