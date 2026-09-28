import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct AccountCreateResponse: JSONResponseRepresentable {
    var description: String = "Account response"
    var schema = AccountCreateResponseSchema().reference()
}
