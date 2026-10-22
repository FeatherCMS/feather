import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthMagicLinkListResponse: JSONResponseRepresentable {
    var description: String = "AuthMagicLink list response"
    var schema = AuthMagicLinkListSchema().reference()
}
