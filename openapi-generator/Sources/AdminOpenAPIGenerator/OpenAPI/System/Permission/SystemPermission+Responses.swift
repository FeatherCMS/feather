import FeatherOpenAPI
import SharedOpenAPIComponents

struct SystemPermissionDetailResponse: JSONResponseRepresentable {
    var description: String = "SystemPermission response"
    var schema = SystemPermissionDetailSchema().reference()
}

struct SystemPermissionListResponse: JSONResponseRepresentable {
    var description: String = "SystemPermission list response"
    var schema = SystemPermissionListSchema().reference()
}

struct SystemPermissionFiltersResponse: JSONResponseRepresentable {
    var description: String = "SystemPermission filter response"
    var schema = SearchFilterSchema().reference()
}
