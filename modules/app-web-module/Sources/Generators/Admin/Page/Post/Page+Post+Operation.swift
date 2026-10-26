import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Page.Post {
    struct Operation: Page.Operation, BearerProtectedOperation {
        var operationId: String? { "pageCreate" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                201: Page.Get.Response().reference()
            ]
        }
    }
}
