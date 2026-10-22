import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct PageGetOperation: PageIDOperation {
    var responseMap: ResponseMap {
        [
            200: PageDetailResponse().reference(),
            404: CustomResponse(description: "Page not found"),
        ]
    }
}
