import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthCredentialCreateOperation: AuthCredentialOperation {
    var operationId: String? { "authCredentialCreate" }

    var requestBody: (any RequestBodyRepresentable)? {
        AuthCredentialRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [201: AuthCredentialDetailResponse().reference()]
    }
}
