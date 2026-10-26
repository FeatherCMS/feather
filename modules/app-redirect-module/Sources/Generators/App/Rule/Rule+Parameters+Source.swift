import FeatherOpenAPI

extension Rule.Parameters {
    struct Source: QueryParameterRepresentable {
        var openAPIIdentifier: String { "RedirectSourceParameter" }
        var name: String { "source" }
        var description: String? { "Public redirect source path" }
        var schema: any OpenAPISchemaRepresentable {
            Rule.Schemas.Source().reference()
        }
    }
}
