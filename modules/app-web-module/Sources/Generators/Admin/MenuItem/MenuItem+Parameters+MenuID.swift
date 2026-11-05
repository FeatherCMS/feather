import FeatherOpenAPI

extension MenuItem.Parameters {
    struct MenuID: PathParameterRepresentable {
        var openAPIIdentifier: String { "MenuItemMenuIdParameter" }
        var name: String { "menuId" }
        var description: String? { "Menu id" }
        var schema: any OpenAPISchemaRepresentable {
            Menu.Schemas.ID().reference()
        }
    }
}
