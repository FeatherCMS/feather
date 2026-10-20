import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity.Get {
    struct Operation: Identity.IdentifiableOperation {
        var operationId: String? { "userIdentityGet" }
        var responseMap: ResponseMap {
            [
                200: UserIdentityDetailResponse().reference(),
                404: CustomResponse(description: "UserIdentity not found"),
            ]
        }
    }
}
