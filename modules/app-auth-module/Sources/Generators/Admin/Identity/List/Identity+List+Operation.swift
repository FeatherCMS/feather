import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity.Session.List {
    struct Operation: Identity.IdentifiableOperation {
        var operationId: String? { "userIdentitySessionList" }

        var responseMap: ResponseMap {
            [
                200: UserIdentitySessionListResponse().reference(),
                404: CustomResponse(description: "UserIdentity not found"),
            ]
        }
    }
}
