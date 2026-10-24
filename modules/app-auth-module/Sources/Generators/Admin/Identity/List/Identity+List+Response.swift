import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity.Session.List {
    struct UserIdentitySessionListResponse: JSONResponseRepresentable {
        var openAPIIdentifier: String { "UserIdentitySessionListResponse" }
        var description: String = "UserIdentity session list response"
        var schema = Identity.Session.List.Schema()
            .reference()
    }
}
