import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthCredentialListResponse: JSONResponseRepresentable {
    var description: String = "AuthCredential list response"
    var schema = AuthCredentialListSchema().reference()
}
