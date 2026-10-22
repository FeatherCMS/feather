import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthCredentialListOperation: AuthCredentialOperation {
    var operationId: String? { "authCredentialList" }

    var responseMap: ResponseMap {
        [200: AuthCredentialListResponse().reference()]
    }
}
