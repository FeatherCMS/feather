import FeatherOpenAPI

extension Author.List {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog author list"
        var schema = BlogAuthorListSchema().reference()
    }
}
