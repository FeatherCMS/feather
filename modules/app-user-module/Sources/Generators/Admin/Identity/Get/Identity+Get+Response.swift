import FeatherOpenAPI

extension Identity.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "UserIdentityDetailResponse" }
        var description: String = "UserIdentity response"
        var schema = Identity.Schemas.Detail().reference()
    }
}
