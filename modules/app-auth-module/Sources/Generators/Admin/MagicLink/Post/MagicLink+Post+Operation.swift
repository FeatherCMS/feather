import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthMagicLinkCreateOperation: AuthMagicLinkOperation {
    var operationId: String? { "authMagicLinkCreate" }

    var requestBody: (any RequestBodyRepresentable)? {
        AuthMagicLinkManagementRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [201: AuthMagicLinkDetailResponse().reference()]
    }
}
