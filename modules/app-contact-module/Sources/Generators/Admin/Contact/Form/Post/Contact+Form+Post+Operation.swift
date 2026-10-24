import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

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
