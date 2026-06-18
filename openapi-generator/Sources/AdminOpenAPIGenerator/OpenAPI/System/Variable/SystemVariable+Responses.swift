import FeatherOpenAPI
import SharedOpenAPIComponents

struct SystemVariableDetailResponse: JSONResponseRepresentable {
    var description: String = "SystemVariable response"
    var schema = SystemVariableDetailSchema().reference()
}

struct SystemVariableListResponse: JSONResponseRepresentable {
    var description: String = "SystemVariable list response"
    var schema = SystemVariableListSchema().reference()
}

struct SystemVariableFiltersResponse: JSONResponseRepresentable {
    var description: String = "SystemVariable filter response"
    var schema = SearchFilterSchema().reference()
}
