import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension MagicLink.Get {

    struct AuthMagicLinkDetailResponse: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkDetailResponse" }
        var description: String = "User magic link response"
        var schema = MagicLink.Schemas.AuthMagicLinkDetailSchema().reference()
    }
}
