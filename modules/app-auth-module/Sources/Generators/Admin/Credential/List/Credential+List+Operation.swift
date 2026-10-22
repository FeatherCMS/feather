import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Credential.List {

    struct Operation: Credential.Operation {
        var operationId: String? { "authCredentialList" }

        var responseMap: ResponseMap {
            [200: Credential.List.AuthCredentialListResponse().reference()]
        }
    }
}
