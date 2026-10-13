import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct BlogPostDetailResponse: JSONResponseRepresentable {
    var description: String = "BlogPost response"
    var schema = BlogPostDetailSchema().reference()
}

struct BlogPostListResponse: JSONResponseRepresentable {
    var description: String = "BlogPost list response"
    var schema = BlogPostListSchema().reference()
}
