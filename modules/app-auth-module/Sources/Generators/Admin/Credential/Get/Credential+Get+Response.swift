import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthCredentialDetailResponse: JSONResponseRepresentable {
    var description: String = "User credential response"
    var schema = AuthCredentialDetailSchema().reference()
}
