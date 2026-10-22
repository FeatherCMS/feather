import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.ID.Get {
    struct Operation: Menu.ID.Operation, BearerProtectedOperation {
        var operationId: String? { "webMenuGet" }
        var responseMap: ResponseMap {
            [
                200: WebMenuDetailResponse().reference(),
                404: CustomResponse(description: "WebMenu not found"),
            ]
        }
    }
}
