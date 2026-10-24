import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Contact.Form.List {
    struct Operation: Contact.Form.Operation {
        var operationId: String? { "contactFormList" }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
