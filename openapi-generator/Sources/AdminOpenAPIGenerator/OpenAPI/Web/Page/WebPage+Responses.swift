import FeatherOpenAPI
import SharedOpenAPIComponents

struct WebPageDetailResponse: JSONResponseRepresentable {
    var description: String = "WebPage response"
    var schema = WebPageDetailSchema().reference()
}

struct WebPageListResponse: JSONResponseRepresentable {
    var description: String = "WebPage list response"
    var schema = WebPageListSchema().reference()
}

struct WebPageFiltersResponse: JSONResponseRepresentable {
    var description: String = "WebPage filter response"
    var schema = SearchFilterSchema().reference()
}
