import FeatherOpenAPI

extension Tag.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog tag detail"
        var schema = BlogTagDetailSchema().reference()
    }
}
