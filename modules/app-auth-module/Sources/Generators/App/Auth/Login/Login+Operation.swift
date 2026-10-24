import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Auth.Login {
    struct Operation: Auth.Operation {
        var operationId: String? { "authLogin" }

        var requestBody: (any RequestBodyRepresentable)? {
            Auth.Login.RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [200: Auth.Response().reference()]
        }
    }
}
