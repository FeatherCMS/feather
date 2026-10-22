import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Auth.Me {
    struct Operation: Auth.Operation, BearerProtectedOperation {
        var operationId: String? { "authMe" }

        var responseMap: ResponseMap {
            [200: Auth.Me.Response().reference()]
        }
    }
}
