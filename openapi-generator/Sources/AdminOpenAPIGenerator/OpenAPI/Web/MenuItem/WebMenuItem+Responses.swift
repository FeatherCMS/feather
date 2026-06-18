import FeatherOpenAPI
import SharedOpenAPIComponents

struct WebMenuItemDetailResponse: JSONResponseRepresentable {
    var description: String = "WebMenuItem response"
    var schema = WebMenuItemDetailSchema().reference()
}

struct WebMenuItemListResponse: JSONResponseRepresentable {
    var description: String = "WebMenuItem list response"
    var schema = WebMenuItemListSchema().reference()
}

struct WebMenuItemFiltersResponse: JSONResponseRepresentable {
    var description: String = "WebMenuItem filter response"
    var schema = SearchFilterSchema().reference()
}
