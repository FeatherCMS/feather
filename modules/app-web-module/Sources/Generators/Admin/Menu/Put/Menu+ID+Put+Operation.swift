import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.ID.Put {
    struct Operation: Menu.ID.Operation, BearerProtectedOperation {
        var operationId: String? { "menuUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            MenuUpdateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: MenuDetailResponse().reference(),
                404: CustomResponse(description: "Menu not found"),
            ]
        }
    }
}
