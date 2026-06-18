import FeatherOpenAPI
import SharedOpenAPIComponents

struct WebMenuDetailResponse: JSONResponseRepresentable {
    var description: String = "WebMenu response"
    var schema = WebMenuDetailSchema().reference()
}

struct WebMenuListResponse: JSONResponseRepresentable {
    var description: String = "WebMenu list response"
    var schema = WebMenuListSchema().reference()
}

struct WebMenuFiltersResponse: JSONResponseRepresentable {
    var description: String = "WebMenu filter response"
    var schema = SearchFilterSchema().reference()
}
