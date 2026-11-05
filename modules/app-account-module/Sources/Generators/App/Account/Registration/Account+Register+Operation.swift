import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Account.Register {
    struct Operation: OperationRepresentable {
        var operationId: String? { "accountRegister" }
        var tags: [any TagRepresentable] { [Account.Tag()] }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Account.Auth.Response().reference()]
        }
    }
}
