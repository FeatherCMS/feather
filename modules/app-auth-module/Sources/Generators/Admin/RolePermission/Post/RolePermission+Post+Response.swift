import FeatherOpenAPI

struct AuthRolePermissionDetailResponse: JSONResponseRepresentable {
    var description: String = "AuthRolePermission response"
    var schema = AuthRolePermissionDetailSchema().reference()
}
