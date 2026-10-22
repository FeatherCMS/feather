import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct WebPageListOperation: WebPageOperation {
    var responseMap: ResponseMap {
        [
            200: WebPageListResponse().reference()
        ]
    }
}
