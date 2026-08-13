import FeatherOpenAPI

struct AuthRolePermissionDetailResponse: JSONResponseRepresentable {
    var description: String = "AuthRolePermission response"
    var schema = AuthRolePermissionDetailSchema().reference()
}

struct AuthRolePermissionListResponse: JSONResponseRepresentable {
    var description: String = "AuthRolePermission list response"
    var schema = AuthRolePermissionListSchema().reference()
}
