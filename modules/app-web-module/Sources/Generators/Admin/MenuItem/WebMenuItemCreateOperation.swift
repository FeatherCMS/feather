import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

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
