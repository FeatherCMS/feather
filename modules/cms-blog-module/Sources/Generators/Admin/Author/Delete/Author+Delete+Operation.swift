import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author.Delete {
    struct Operation: Author.Operation, DeleteOperation {
        var operationId: String? { "blogAuthorDelete" }
    }
}
