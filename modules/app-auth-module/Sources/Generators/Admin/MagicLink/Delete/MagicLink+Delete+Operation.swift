import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthMagicLinkRemoveOperation: AuthMagicLinkOperation, DeleteOperation {
    var operationId: String? { "authMagicLinkRemove" }
}
