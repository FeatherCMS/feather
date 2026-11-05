import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Account.Create {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AccountCreateResponse" }
        var description: String = "Account response"
        var schema = ResponseSchema().reference()
    }
}
