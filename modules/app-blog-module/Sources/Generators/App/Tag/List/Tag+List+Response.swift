import BlogSchemaSupport
import FeatherOpenAPI

extension Tag.List {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog tag list"
        var schema = BlogTagListSchema().reference()
    }
}
