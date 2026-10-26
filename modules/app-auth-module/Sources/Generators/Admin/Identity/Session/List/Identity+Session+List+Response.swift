import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity.Session.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "UserIdentitySessionListResponse" }
        var description: String = "UserIdentity session list response"
        var schema = Schema().reference()
    }
}
