import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension MenuItem.Put {
    struct Operation: MenuItem.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "menuItemUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: MenuItem.Get.Response().reference(),
                404: CustomResponse(description: "MenuItem not found"),
            ]
        }
    }
}
