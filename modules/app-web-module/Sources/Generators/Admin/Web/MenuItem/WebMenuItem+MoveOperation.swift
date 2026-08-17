import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct WebMenuItemMoveOperation: WebMenuItemIDOperation {
    var requestBody: RequestBodyRepresentable? {
        WebMenuItemMoveRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "WebMenuItem moved"),
            404: CustomResponse(description: "WebMenuItem not found")
        ]
    }
}
