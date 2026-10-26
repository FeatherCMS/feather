import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.ID.Put {
    struct Operation: Menu.ID.Operation, BearerProtectedOperation {
        var operationId: String? { "menuUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Menu.ID.Get.Response().reference(),
                404: CustomResponse(description: "Menu not found"),
            ]
        }
    }
}
