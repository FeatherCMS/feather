import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.ID.Patch {
    struct Operation: Menu.ID.Operation, BearerProtectedOperation {
        var operationId: String? { "webMenuPatch" }
        var requestBody: (any RequestBodyRepresentable)? {
            WebMenuPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: WebMenuDetailResponse().reference(),
                404: CustomResponse(description: "WebMenu not found"),
            ]
        }
    }
}
