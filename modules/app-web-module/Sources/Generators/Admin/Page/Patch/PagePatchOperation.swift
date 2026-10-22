import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct PagePatchOperation: PageIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        PagePatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: PageDetailResponse().reference(),
            404: CustomResponse(description: "Page not found"),
        ]
    }
}
