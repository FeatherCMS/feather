import FeatherOpenAPI

struct WebMenuIdParameter: PathParameterRepresentable {
    var name: String { "webMenuId" }
    var description: String? { "WebMenu id" }
    var schema: any OpenAPISchemaRepresentable {
        WebMenuIdField().reference()
    }
}
