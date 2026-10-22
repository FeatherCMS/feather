import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

struct WebMenuItemListOperation: WebMenuItemMenuOperation {
    var responseMap: ResponseMap {
        [
            200: WebMenuItemListResponse().reference()
        ]
    }
}
