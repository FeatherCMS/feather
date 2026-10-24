import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.ID.Patch {
    struct Operation: Menu.ID.Operation, BearerProtectedOperation {
        var operationId: String? { "menuPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                MenuIdParameter().reference(),
                Menu.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            MenuPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: MenuDetailResponse().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "Menu not found"),
            ]
        }
    }
}
