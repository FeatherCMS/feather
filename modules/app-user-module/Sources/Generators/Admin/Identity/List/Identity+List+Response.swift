import FeatherOpenAPI

extension Identity.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "UserIdentityListResponse" }
        var description: String = "User identity list response"
        var schema = Schema().reference()
    }
}
