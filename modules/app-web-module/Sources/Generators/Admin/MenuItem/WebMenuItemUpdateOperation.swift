import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

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
