import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogPost.Delete {
    struct Operation: BlogPost.Operation, DeleteOperation {
        var operationId: String? { "blogPostDelete" }
    }
}
