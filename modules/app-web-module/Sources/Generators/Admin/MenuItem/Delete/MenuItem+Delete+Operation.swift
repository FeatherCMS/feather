import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension MenuItem.Delete {
    struct Operation: MenuItem.MenuOperation, DeleteOperation {
        var operationId: String? { "menuItemRemove" }
    }
}
