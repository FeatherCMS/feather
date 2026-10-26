import BlogSchemaSupport
import FeatherOpenAPI

extension Author.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog author detail"
        var schema = BlogAuthorDetailSchema().reference()
    }
}
