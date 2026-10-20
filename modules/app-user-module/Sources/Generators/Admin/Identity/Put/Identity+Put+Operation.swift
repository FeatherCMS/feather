import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity.Put {
    struct Operation: Identity.IdentifiableOperation {
        var operationId: String? { "userIdentityUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            UserIdentityUpdateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: UserIdentityDetailResponse().reference(),
                404: CustomResponse(description: "UserIdentity not found"),
            ]
        }
    }
}
