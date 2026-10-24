import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension MenuItem.Put {
    struct Operation: MenuItem.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "menuItemUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            MenuItemUpdateRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: MenuItemDetailResponse().reference(),
                404: CustomResponse(description: "MenuItem not found"),
            ]
        }
    }
}
