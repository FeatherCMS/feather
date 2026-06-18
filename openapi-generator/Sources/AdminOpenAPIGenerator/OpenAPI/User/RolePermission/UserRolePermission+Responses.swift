import FeatherOpenAPI

struct UserRolePermissionDetailResponse: JSONResponseRepresentable {
    var description: String = "UserRolePermission response"
    var schema = UserRolePermissionDetailSchema().reference()
}

struct UserRolePermissionListResponse: JSONResponseRepresentable {
    var description: String = "UserRolePermission list response"
    var schema = UserRolePermissionListSchema().reference()
}
