import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Form.Post {
    struct Operation: Contact.Form.Operation {
        var operationId: String? { "contactFormCreate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Contact.Form.Get.Response().reference()]
        }
    }
}
