import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.Delete {
    struct Operation: Menu.Operation, DeleteOperation {
        var operationId: String? { "menuRemove" }
    }
}
