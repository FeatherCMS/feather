import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthor.Delete {
    struct Operation: BlogAuthor.Operation, DeleteOperation {
        var operationId: String? { "blogAuthorDelete" }
    }
}
