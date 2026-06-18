import FeatherOpenAPI
import SharedOpenAPIComponents

struct UserRoleDetailResponse: JSONResponseRepresentable {
    var description: String = "UserRole response"
    var schema = UserRoleDetailSchema().reference()
}

struct UserRoleListResponse: JSONResponseRepresentable {
    var description: String = "UserRole list response"
    var schema = UserRoleListSchema().reference()
}

struct UserRoleFiltersResponse: JSONResponseRepresentable {
    var description: String = "UserRole filter response"
    var schema = SearchFilterSchema().reference()
}
