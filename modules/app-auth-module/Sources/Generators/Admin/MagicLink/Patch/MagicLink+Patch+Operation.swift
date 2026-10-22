import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthMagicLinkPatchOperation: AuthMagicLinkIdOperation {
    var operationId: String? { "authMagicLinkPatch" }

    var parameters: [any ParameterRepresentable] {
        [
            AuthMagicLinkIdParameter().reference(),
            AuthMagicLinkUpdateMaskParameter().reference(),
        ]
    }

    var requestBody: (any RequestBodyRepresentable)? {
        AuthMagicLinkPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: AuthMagicLinkDetailResponse().reference(),
            400: CustomResponse(description: "Invalid update mask"),
            404: CustomResponse(description: "AuthMagicLink not found"),
        ]
    }
}
