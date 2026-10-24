import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.Post {
    struct Operation: Menu.Operation, BearerProtectedOperation {
        var operationId: String? { "menuCreate" }
        var requestBody: (any RequestBodyRepresentable)? {
            MenuRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: MenuDetailResponse().reference()]
        }
    }
}
