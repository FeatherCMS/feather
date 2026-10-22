import FeatherOpenAPI

struct AuthRolePermissionListResponse: JSONResponseRepresentable {
    var description: String = "AuthRolePermission list response"
    var schema = AuthRolePermissionListSchema().reference()
}
