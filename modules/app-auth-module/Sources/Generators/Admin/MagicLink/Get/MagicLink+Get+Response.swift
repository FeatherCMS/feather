import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension MagicLink.Get {

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkDetailResponse" }
        var description: String = "User magic link response"
        var schema = Schema().reference()
    }
}
