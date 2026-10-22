import FeatherOpenAPI

extension RolePermission.Post {

    struct AuthRolePermissionDetailResponse: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionDetailResponse" }
        var description: String = "AuthRolePermission response"
        var schema = RolePermission.Schemas.AuthRolePermissionDetailSchema()
            .reference()
    }
}
