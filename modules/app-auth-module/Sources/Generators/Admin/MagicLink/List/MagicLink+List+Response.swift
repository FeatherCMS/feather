import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension MagicLink.List {

    struct AuthMagicLinkListResponse: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkListResponse" }
        var description: String = "AuthMagicLink list response"
        var schema = MagicLink.Schemas.AuthMagicLinkListSchema().reference()
    }
}
