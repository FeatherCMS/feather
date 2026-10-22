import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

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
