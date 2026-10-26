import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.Post {
    struct Operation: Menu.Operation, BearerProtectedOperation {
        var operationId: String? { "menuCreate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Menu.ID.Get.Response().reference()]
        }
    }
}
