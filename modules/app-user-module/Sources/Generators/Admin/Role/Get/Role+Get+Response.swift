import FeatherOpenAPI

extension Role.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "UserRoleDetailResponse" }
        var description: String = "UserRole response"
        var schema = Schema().reference()
    }
}
