import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension MenuItem.Delete {
    struct Operation: MenuItem.MenuOperation, DeleteOperation {
        var operationId: String? { "menuItemRemove" }
    }
}
