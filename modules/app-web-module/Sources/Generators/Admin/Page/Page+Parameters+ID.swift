import FeatherOpenAPI

extension Page.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "PageIdParameter" }
        var name: String { "pageId" }
        var description: String? { "Page id" }
        var schema: any OpenAPISchemaRepresentable {
            Page.Schemas.ID().reference()
        }
    }
}
