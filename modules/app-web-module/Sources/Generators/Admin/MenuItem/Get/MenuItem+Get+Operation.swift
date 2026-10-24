import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension MenuItem.Get {
    struct Operation: MenuItem.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "menuItemGet" }
        var responseMap: ResponseMap {
            [
                200: MenuItemDetailResponse().reference(),
                404: CustomResponse(description: "MenuItem not found"),
            ]
        }
    }
}
