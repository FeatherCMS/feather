import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.ID.Put {
    struct Operation: Menu.ID.Operation, BearerProtectedOperation {
        var operationId: String? { "webMenuUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            WebMenuUpdateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: WebMenuDetailResponse().reference(),
                404: CustomResponse(description: "WebMenu not found"),
            ]
        }
    }
}
