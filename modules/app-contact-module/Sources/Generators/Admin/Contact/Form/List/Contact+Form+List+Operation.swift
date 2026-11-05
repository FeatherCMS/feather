import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Form.List {
    struct Operation: Contact.Form.Operation {
        var operationId: String? { "contactFormList" }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
