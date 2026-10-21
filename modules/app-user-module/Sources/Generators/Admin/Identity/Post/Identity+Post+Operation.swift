import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity.Post {
    struct Operation: Identity.Operation {
        var operationId: String? { "userIdentityPost" }
        var summary: String? { "Create user identity" }
        var description: String? { "Creates a user identity" }
        var requestBody: (any RequestBodyRepresentable)? {
            Identity.Post.RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Identity.Get.Response().reference()]
        }
    }
}
