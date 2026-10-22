public import FeatherOpenAPI

struct MenuItemMenuIdParameter: PathParameterRepresentable {
    var name: String { "menuId" }
    var description: String? { "Menu id" }
    var schema: any OpenAPISchemaRepresentable {
        MenuIdField().reference()
    }
}

struct MenuItemIdParameter: PathParameterRepresentable {
    var name: String { "menuItemId" }
    var description: String? { "MenuItem id" }
    var schema: any OpenAPISchemaRepresentable {
        MenuItemIdField().reference()
    }
}
