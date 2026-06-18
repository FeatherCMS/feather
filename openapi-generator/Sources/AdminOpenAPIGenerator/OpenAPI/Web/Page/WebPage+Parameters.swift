import FeatherOpenAPI

struct WebPageIdParameter: PathParameterRepresentable {
    var name: String { "webPageId" }
    var description: String? { "WebPage id" }
    var schema: any OpenAPISchemaRepresentable {
        WebPageIdField().reference()
    }
}
