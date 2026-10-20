import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity.Patch {
    struct Operation: Identity.IdentifiableOperation {
        var operationId: String? { "userIdentityPatch" }
        var requestBody: (any RequestBodyRepresentable)? {
            UserIdentityPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: UserIdentityDetailResponse().reference(),
                404: CustomResponse(description: "UserIdentity not found"),
            ]
        }
    }
}
