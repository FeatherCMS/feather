import FeatherOpenAPI
import SharedOpenAPIComponents

struct BlogAuthorDetailResponse: JSONResponseRepresentable {
    var description: String = "BlogAuthor response"
    var schema = BlogAuthorDetailSchema().reference()
}

struct BlogAuthorListResponse: JSONResponseRepresentable {
    var description: String = "BlogAuthor list response"
    var schema = BlogAuthorListSchema().reference()
}

struct BlogAuthorFiltersResponse: JSONResponseRepresentable {
    var description: String = "BlogAuthor filter response"
    var schema = SearchFilterSchema().reference()
}
