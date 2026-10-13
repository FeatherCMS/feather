import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct SystemPermissionDetailResponse: JSONResponseRepresentable {
    var description: String = "SystemPermission response"
    var schema = SystemPermissionDetailSchema().reference()
}

struct SystemPermissionListResponse: JSONResponseRepresentable {
    var description: String = "SystemPermission list response"
    var schema = SystemPermissionListSchema().reference()
}
