import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Form.Delete {
    struct Operation: Contact.Form.Operation, DeleteOperation {
        var operationId: String? { "contactFormRemove" }
    }
}
