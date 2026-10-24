import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

extension Page.Delete {
    struct Operation: Page.Operation, DeleteOperation {
        var operationId: String? { "pageRemove" }
    }
}
