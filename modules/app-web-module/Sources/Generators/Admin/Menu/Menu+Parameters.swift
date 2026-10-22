public import FeatherOpenAPI

struct MenuIdParameter: PathParameterRepresentable {
    var name: String { "menuId" }
    var description: String? { "Menu id" }
    var schema: any OpenAPISchemaRepresentable {
        MenuIdField().reference()
    }
}
