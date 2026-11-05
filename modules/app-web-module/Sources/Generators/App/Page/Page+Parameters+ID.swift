import FeatherOpenAPI

extension Page.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "PageIDParameter" }
        var name: String { "id" }
        var schema: any OpenAPISchemaRepresentable {
            PageIdField().reference()
        }
    }
}
