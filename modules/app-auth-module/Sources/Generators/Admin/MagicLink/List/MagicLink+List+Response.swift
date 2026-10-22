import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension MagicLink.List {

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkListResponse" }
        var description: String = "AuthMagicLink list response"
        var schema = MagicLink.List.Schema().reference()
    }
}
