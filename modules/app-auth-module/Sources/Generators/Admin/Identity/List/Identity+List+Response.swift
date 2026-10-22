import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct UserIdentitySessionListResponse: JSONResponseRepresentable {
    var description: String = "UserIdentity session list response"
    var schema = UserAuthSessionListSchema().reference()
}
