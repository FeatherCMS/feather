import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthCredentialPatchOperation: AuthCredentialIdOperation {
    var operationId: String? { "authCredentialPatch" }

    var parameters: [any ParameterRepresentable] {
        [
            AuthCredentialIdParameter().reference(),
            AuthCredentialUpdateMaskParameter().reference(),
        ]
    }

    var requestBody: (any RequestBodyRepresentable)? {
        AuthCredentialPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: AuthCredentialDetailResponse().reference(),
            400: CustomResponse(description: "Invalid update mask"),
            404: CustomResponse(description: "AuthCredential not found"),
        ]
    }
}
