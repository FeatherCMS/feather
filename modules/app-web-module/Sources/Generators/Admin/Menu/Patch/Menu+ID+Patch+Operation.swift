import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.ID.Patch {
    struct Operation: Menu.ID.Operation, BearerProtectedOperation {
        var operationId: String? { "menuPatch" }
        var requestBody: (any RequestBodyRepresentable)? {
            MenuPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: MenuDetailResponse().reference(),
                404: CustomResponse(description: "Menu not found"),
            ]
        }
    }
}
