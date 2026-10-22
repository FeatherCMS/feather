import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct BlogAuthorLinkDetailResponse: JSONResponseRepresentable {
    var description: String = "BlogAuthorLink response"
    var schema = BlogAuthorLinkDetailSchema().reference()
}

struct BlogAuthorLinkListResponse: JSONResponseRepresentable {
    var description: String = "BlogAuthorLink list response"
    var schema = BlogAuthorLinkListSchema().reference()
}
