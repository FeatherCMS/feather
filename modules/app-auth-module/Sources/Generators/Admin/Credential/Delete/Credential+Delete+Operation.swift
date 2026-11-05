import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Credential.Delete {

    struct Operation: Credential.Operation, DeleteOperation {
        var operationId: String? { "authCredentialRemove" }
    }
}
