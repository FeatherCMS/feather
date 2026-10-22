import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthMagicLinkListOperation: AuthMagicLinkOperation {
    var operationId: String? { "authMagicLinkList" }

    var responseMap: ResponseMap {
        [200: AuthMagicLinkListResponse().reference()]
    }
}
