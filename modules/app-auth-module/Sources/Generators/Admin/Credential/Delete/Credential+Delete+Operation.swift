import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthCredentialRemoveOperation: AuthCredentialOperation, DeleteOperation {
    var operationId: String? { "authCredentialRemove" }
}
