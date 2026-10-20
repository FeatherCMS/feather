import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity.Post {
    struct Operation: Identity.Operation {
        var operationId: String? { "userIdentityPost" }
        var summary: String? { "Create user identity" }
        var description: String? { "Creates a user identity" }
        var requestBody: (any RequestBodyRepresentable)? {
            UserIdentityCreateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: UserIdentityDetailResponse().reference()]
        }
    }
}
