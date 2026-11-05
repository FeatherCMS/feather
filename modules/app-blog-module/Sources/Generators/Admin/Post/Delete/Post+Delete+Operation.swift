import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post.Delete {
    struct Operation: Post.Operation, DeleteOperation {
        var operationId: String? { "blogPostDelete" }
    }
}
