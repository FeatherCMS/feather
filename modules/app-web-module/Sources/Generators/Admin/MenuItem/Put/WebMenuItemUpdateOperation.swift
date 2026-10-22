import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct WebMenuItemUpdateOperation: WebMenuItemIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        WebMenuItemUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebMenuItemDetailResponse().reference(),
            404: CustomResponse(description: "WebMenuItem not found"),
        ]
    }
}
