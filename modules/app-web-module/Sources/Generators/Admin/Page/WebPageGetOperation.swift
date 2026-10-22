import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

struct WebPageGetOperation: WebPageIDOperation {
    var responseMap: ResponseMap {
        [
            200: WebPageDetailResponse().reference(),
            404: CustomResponse(description: "WebPage not found"),
        ]
    }
}
