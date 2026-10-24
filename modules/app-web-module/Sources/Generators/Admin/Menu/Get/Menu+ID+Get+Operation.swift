import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.ID.Get {
    struct Operation: Menu.ID.Operation, BearerProtectedOperation {
        var operationId: String? { "menuGet" }
        var responseMap: ResponseMap {
            [
                200: MenuDetailResponse().reference(),
                404: CustomResponse(description: "Menu not found"),
            ]
        }
    }
}
