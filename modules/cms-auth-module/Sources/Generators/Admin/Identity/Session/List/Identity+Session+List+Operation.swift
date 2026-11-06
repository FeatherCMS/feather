import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Identity.Session.List {
    struct Operation: Identity.IdentifiableOperation {
        var operationId: String? { "userIdentitySessionList" }

        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "UserIdentity not found"),
            ]
        }
    }
}
