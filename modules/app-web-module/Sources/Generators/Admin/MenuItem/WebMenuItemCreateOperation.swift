import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct WebMenuItemCreateOperation: WebMenuItemMenuOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        WebMenuItemRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: WebMenuItemDetailResponse().reference()
        ]
    }
}
