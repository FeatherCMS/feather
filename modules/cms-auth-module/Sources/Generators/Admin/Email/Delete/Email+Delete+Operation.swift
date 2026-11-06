import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Email.Delete {
    struct Operation: Email.Operation, DeleteOperation {
        var operationId: String? { "authEmailRemove" }
    }
}
