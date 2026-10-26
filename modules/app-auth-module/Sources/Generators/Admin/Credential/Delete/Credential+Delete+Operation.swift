import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Credential.Delete {

    struct Operation: Credential.Operation, DeleteOperation {
        var operationId: String? { "authCredentialRemove" }
    }
}
