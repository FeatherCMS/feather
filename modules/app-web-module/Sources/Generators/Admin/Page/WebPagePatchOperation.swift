import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

struct WebPagePatchOperation: WebPageIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        WebPagePatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebPageDetailResponse().reference(),
            404: CustomResponse(description: "WebPage not found"),
        ]
    }
}
