import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Page.Delete {
    struct Operation: Page.Operation, DeleteOperation {
        var operationId: String? { "pageRemove" }
    }
}
