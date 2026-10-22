import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct UserIdentitySessionListOperation: UserIdentitySessionOperation {
    var operationId: String? { "userIdentitySessionList" }

    var responseMap: ResponseMap {
        [
            200: UserIdentitySessionListResponse().reference(),
            404: CustomResponse(description: "UserIdentity not found"),
        ]
    }
}
