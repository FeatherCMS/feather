import FeatherOpenAPI

extension MenuItem.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "MenuItemIdParameter" }
        var name: String { "menuItemId" }
        var description: String? { "MenuItem id" }
        var schema: any OpenAPISchemaRepresentable {
            MenuItem.Schemas.ID().reference()
        }
    }
}
