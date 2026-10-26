import FeatherOpenAPI

extension Menu.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "MenuIdParameter" }
        var name: String { "menuId" }
        var description: String? { "Menu id" }
        var schema: any OpenAPISchemaRepresentable {
            Menu.Schemas.ID().reference()
        }
    }
}
