import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct WebMenuItemPatchOperation: WebMenuItemIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        WebMenuItemPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebMenuItemDetailResponse().reference(),
            404: CustomResponse(description: "WebMenuItem not found"),
        ]
    }
}
