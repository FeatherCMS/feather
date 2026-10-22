import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

struct WebPageCreateOperation: WebPageOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        WebPageRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: WebPageDetailResponse().reference()
        ]
    }
}
