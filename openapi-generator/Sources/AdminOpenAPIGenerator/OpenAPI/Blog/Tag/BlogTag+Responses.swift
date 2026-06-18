import FeatherOpenAPI
import SharedOpenAPIComponents

struct BlogTagDetailResponse: JSONResponseRepresentable {
    var description: String = "BlogTag response"
    var schema = BlogTagDetailSchema().reference()
}

struct BlogTagListResponse: JSONResponseRepresentable {
    var description: String = "BlogTag list response"
    var schema = BlogTagListSchema().reference()
}

struct BlogTagFiltersResponse: JSONResponseRepresentable {
    var description: String = "BlogTag filter response"
    var schema = SearchFilterSchema().reference()
}
