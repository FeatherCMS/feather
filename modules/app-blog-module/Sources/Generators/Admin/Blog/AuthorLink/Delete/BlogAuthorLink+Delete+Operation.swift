import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthorLink.Delete {
    struct Operation: BlogAuthorLink.Menu.Operation, DeleteOperation {
        var operationId: String? { "blogAuthorLinkDelete" }
    }
}
