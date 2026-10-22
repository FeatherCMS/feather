import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogTag.Delete {
    struct Operation: BlogTag.Operation, DeleteOperation {
        var operationId: String? { "blogTagDelete" }
    }
}
