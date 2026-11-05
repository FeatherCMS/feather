import FeatherOpenAPI

extension Post.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog post detail"
        var schema = BlogPostDetailSchema().reference()
    }
}
