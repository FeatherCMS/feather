import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Identity.Session.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "UserIdentitySessionListResponse" }
        var description: String = "UserIdentity session list response"
        var schema = Schema().reference()
    }
}
