import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Email.Post {
    struct Operation: Email.Operation {
        var operationId: String? { "authEmailCreate" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [201: Email.Get.Response().reference()]
        }
    }

}
