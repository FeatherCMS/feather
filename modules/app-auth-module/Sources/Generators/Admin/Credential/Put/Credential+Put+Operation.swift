import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthCredentialUpdateOperation: AuthCredentialIdOperation {
    var operationId: String? { "authCredentialUpdate" }

    var requestBody: (any RequestBodyRepresentable)? {
        AuthCredentialUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: AuthCredentialDetailResponse().reference(),
            404: CustomResponse(description: "AuthCredential not found"),
        ]
    }
}
