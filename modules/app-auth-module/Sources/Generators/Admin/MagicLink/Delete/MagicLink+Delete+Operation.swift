import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension MagicLink.Delete {

    struct Operation: MagicLink.Operation, DeleteOperation {
        var operationId: String? { "authMagicLinkRemove" }
    }
}
