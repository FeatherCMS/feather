import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthorLink.Delete {
    struct Operation: BlogAuthorLink.Operation, DeleteOperation {
        var operationId: String? { "blogAuthorLinkDelete" }
    }
}
