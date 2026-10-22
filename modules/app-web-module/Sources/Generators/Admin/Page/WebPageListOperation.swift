import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

struct WebPageListOperation: WebPageOperation {
    var responseMap: ResponseMap {
        [
            200: WebPageListResponse().reference()
        ]
    }
}
