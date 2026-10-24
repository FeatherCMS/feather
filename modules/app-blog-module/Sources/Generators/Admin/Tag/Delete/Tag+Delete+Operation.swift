import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Tag.Delete {
    struct Operation: Tag.Operation, DeleteOperation {
        var operationId: String? { "blogTagDelete" }
    }
}
