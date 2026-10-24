import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

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
