import FeatherOpenAPI
import SharedOpenAPIComponents

struct BlogPostDetailResponse: JSONResponseRepresentable {
    var description: String = "BlogPost response"
    var schema = BlogPostDetailSchema().reference()
}

struct BlogPostListResponse: JSONResponseRepresentable {
    var description: String = "BlogPost list response"
    var schema = BlogPostListSchema().reference()
}

struct BlogPostFiltersResponse: JSONResponseRepresentable {
    var description: String = "BlogPost filter response"
    var schema = SearchFilterSchema().reference()
}
