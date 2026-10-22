import FeatherOpenAPI

struct WebMenuItemMenuIdParameter: PathParameterRepresentable {
    var name: String { "webMenuId" }
    var description: String? { "WebMenu id" }
    var schema: any OpenAPISchemaRepresentable {
        WebMenuIdField().reference()
    }
}

struct WebMenuItemIdParameter: PathParameterRepresentable {
    var name: String { "webMenuItemId" }
    var description: String? { "WebMenuItem id" }
    var schema: any OpenAPISchemaRepresentable {
        WebMenuItemIdField().reference()
    }
}
