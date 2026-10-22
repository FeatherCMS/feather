import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct PageUpdateOperation: PageIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        PageUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: PageDetailResponse().reference(),
            404: CustomResponse(description: "Page not found"),
        ]
    }
}
