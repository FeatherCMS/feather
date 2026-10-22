import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct PageCreateOperation: PageOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        PageRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: PageDetailResponse().reference()
        ]
    }
}
