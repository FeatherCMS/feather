import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Field.Post {
    struct Operation: Contact.Field.Operation {
        var operationId: String? { "contactFieldCreate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Contact.Field.Get.Response().reference()]
        }
    }
}
