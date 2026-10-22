import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

struct WebMenuItemGetOperation: WebMenuItemIDOperation {
    var responseMap: ResponseMap {
        [
            200: WebMenuItemDetailResponse().reference(),
            404: CustomResponse(description: "WebMenuItem not found"),
        ]
    }
}
