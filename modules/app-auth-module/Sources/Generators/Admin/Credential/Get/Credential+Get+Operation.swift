import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthCredentialGetOperation: AuthCredentialIdOperation {
    var operationId: String? { "authCredentialGet" }

    var responseMap: ResponseMap {
        [
            200: AuthCredentialDetailResponse().reference(),
            404: CustomResponse(description: "AuthCredential not found"),
        ]
    }
}
