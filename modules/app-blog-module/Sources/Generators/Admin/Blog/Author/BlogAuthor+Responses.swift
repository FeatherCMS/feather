import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct BlogAuthorDetailResponse: JSONResponseRepresentable {
    var description: String = "BlogAuthor response"
    var schema = BlogAuthorDetailSchema().reference()
}

struct BlogAuthorListResponse: JSONResponseRepresentable {
    var description: String = "BlogAuthor list response"
    var schema = BlogAuthorListSchema().reference()
}
