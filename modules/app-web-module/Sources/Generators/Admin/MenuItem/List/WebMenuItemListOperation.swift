import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct WebMenuItemListOperation: WebMenuItemMenuOperation {
    var responseMap: ResponseMap {
        [
            200: WebMenuItemListResponse().reference()
        ]
    }
}
