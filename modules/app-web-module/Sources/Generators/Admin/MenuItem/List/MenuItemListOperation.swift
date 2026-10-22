import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct MenuItemListOperation: MenuItemMenuOperation {
    var responseMap: ResponseMap {
        [
            200: MenuItemListResponse().reference()
        ]
    }
}
