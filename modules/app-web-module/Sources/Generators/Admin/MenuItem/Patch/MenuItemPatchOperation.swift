import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct MenuItemPatchOperation: MenuItemIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        MenuItemPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: MenuItemDetailResponse().reference(),
            404: CustomResponse(description: "MenuItem not found"),
        ]
    }
}
