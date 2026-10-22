import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct MenuItemMoveOperation: MenuItemIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        MenuItemMoveRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            204: NoContentResponse(description: "MenuItem moved"),
            404: CustomResponse(description: "MenuItem not found"),
        ]
    }
}
