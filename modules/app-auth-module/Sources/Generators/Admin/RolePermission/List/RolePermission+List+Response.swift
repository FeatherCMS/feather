import FeatherOpenAPI

extension RolePermission.List {

    struct AuthRolePermissionListResponse: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionListResponse" }
        var description: String = "AuthRolePermission list response"
        var schema = RolePermission.Schemas.AuthRolePermissionListSchema()
            .reference()
    }
}
