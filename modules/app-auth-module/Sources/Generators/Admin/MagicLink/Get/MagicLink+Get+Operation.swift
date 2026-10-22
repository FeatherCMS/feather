import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthMagicLinkGetOperation: AuthMagicLinkIdOperation {
    var operationId: String? { "authMagicLinkGet" }

    var responseMap: ResponseMap {
        [
            200: AuthMagicLinkDetailResponse().reference(),
            404: CustomResponse(description: "AuthMagicLink not found"),
        ]
    }
}
