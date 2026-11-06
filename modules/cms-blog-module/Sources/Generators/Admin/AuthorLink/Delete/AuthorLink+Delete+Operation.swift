import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension AuthorLink.Delete {
    struct Operation: AuthorLink.Operation, DeleteOperation {
        var operationId: String? { "blogAuthorLinkDelete" }
    }
}
