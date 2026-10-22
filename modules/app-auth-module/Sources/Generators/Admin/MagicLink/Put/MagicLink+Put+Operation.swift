import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthMagicLinkUpdateOperation: AuthMagicLinkIdOperation {
    var operationId: String? { "authMagicLinkUpdate" }

    var requestBody: (any RequestBodyRepresentable)? {
        AuthMagicLinkUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: AuthMagicLinkDetailResponse().reference(),
            404: CustomResponse(description: "AuthMagicLink not found"),
        ]
    }
}
