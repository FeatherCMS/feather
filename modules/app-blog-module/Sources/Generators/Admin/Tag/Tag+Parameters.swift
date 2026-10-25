import FeatherOpenAPI

extension Tag {
    enum Parameters {}
}

extension Tag.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "BlogTagIdParameter" }
        var name: String { "blogTagId" }
        var description: String? { "Blog tag identifier" }
        var schema: any OpenAPISchemaRepresentable {
            Tag.Schemas.ID().reference()
        }
    }
}
