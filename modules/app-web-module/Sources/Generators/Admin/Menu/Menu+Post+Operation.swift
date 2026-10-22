import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.Post {
    struct Operation: Menu.Operation, BearerProtectedOperation {
        var operationId: String? { "webMenuCreate" }
        var requestBody: (any RequestBodyRepresentable)? {
            WebMenuRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: WebMenuDetailResponse().reference()]
        }
    }
}
