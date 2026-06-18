import FeatherOpenAPI
import SharedOpenAPIComponents

struct BlogAuthorLinkDetailResponse: JSONResponseRepresentable {
    var description: String = "BlogAuthorLink response"
    var schema = BlogAuthorLinkDetailSchema().reference()
}

struct BlogAuthorLinkListResponse: JSONResponseRepresentable {
    var description: String = "BlogAuthorLink list response"
    var schema = BlogAuthorLinkListSchema().reference()
}

struct BlogAuthorLinkFiltersResponse: JSONResponseRepresentable {
    var description: String = "BlogAuthorLink filter response"
    var schema = SearchFilterSchema().reference()
}
