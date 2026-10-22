public import FeatherOpenAPI

struct PageIdParameter: PathParameterRepresentable {
    var name: String { "pageId" }
    var description: String? { "Page id" }
    var schema: any OpenAPISchemaRepresentable {
        PageIdField().reference()
    }
}
