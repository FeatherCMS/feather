import BlogSharedOpenAPIGenerator
import FeatherOpenAPI

extension Post.List {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog post list"
        var schema = BlogPostListSchema().reference()
    }
}
