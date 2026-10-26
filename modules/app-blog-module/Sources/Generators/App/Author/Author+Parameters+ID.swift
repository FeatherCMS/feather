import BlogSchemaSupport
import FeatherOpenAPI

extension Author.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "BlogAuthorIdParameter" }
        var name: String { "id" }
        var description: String? { "Blog author identifier" }
        var schema: any OpenAPISchemaRepresentable {
            BlogAuthorIdField().reference()
        }
    }
}
