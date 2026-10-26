import FeatherOpenAPI

extension RolePermission.List {

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionListResponse" }
        var description: String = "AuthRolePermission list response"
        var schema = Schema()
            .reference()
    }
}
