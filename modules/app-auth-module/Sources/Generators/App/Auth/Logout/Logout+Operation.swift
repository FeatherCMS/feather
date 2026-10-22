import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Auth.Logout {
    struct Operation: Auth.Operation, BearerProtectedOperation {
        var operationId: String? { "authLogout" }

        var responseMap: ResponseMap {
            [204: NoContentResponse(description: "Logged out")]
        }
    }
}
