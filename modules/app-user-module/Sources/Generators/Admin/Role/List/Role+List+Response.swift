import FeatherOpenAPI

extension Role.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "UserRoleListResponse" }
        var description: String = "User role list response"
        var schema = Schema().reference()
    }
}
