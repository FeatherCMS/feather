import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Page.Delete {
    struct Operation: Page.Operation, DeleteOperation {
        var operationId: String? { "pageRemove" }
    }
}
