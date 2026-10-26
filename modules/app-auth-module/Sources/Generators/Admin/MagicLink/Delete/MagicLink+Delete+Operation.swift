import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension MagicLink.Delete {

    struct Operation: MagicLink.Operation, DeleteOperation {
        var operationId: String? { "authMagicLinkRemove" }
    }
}
