import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct PageListOperation: PageOperation {
    var responseMap: ResponseMap {
        [
            200: PageListResponse().reference()
        ]
    }
}
