import FeatherOpenAPI

extension RolePermission.Post {

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionDetailResponse" }
        var description: String = "AuthRolePermission response"
        var schema = DetailSchema()
            .reference()
    }
}
