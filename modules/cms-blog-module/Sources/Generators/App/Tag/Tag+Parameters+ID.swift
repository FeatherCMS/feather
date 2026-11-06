import FeatherOpenAPI

extension Tag.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "BlogTagIdParameter" }
        var name: String { "id" }
        var description: String? { "Blog tag identifier" }
        var schema: any OpenAPISchemaRepresentable {
            BlogTagIdField().reference()
        }
    }
}
