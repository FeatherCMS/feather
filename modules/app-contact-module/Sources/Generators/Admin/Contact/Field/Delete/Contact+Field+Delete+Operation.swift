import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Field.Delete {
    struct Operation: Contact.Field.Operation, DeleteOperation {
        var operationId: String? { "contactFieldRemove" }
    }
}
