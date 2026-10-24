import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

extension MenuItem.Delete {
    struct Operation: MenuItem.MenuOperation, DeleteOperation {
        var operationId: String? { "menuItemRemove" }
    }
}
