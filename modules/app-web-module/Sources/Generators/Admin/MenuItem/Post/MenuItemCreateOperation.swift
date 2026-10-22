import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct MenuItemCreateOperation: MenuItemMenuOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        MenuItemRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: MenuItemDetailResponse().reference()
        ]
    }
}
