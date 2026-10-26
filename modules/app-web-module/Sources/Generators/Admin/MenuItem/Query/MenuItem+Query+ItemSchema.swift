import FeatherOpenAPI

extension MenuItem.Query {
    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": MenuItem.Schemas.ID().reference(),
                "menuId": Menu.Schemas.ID().reference(),
                "label": MenuItem.Schemas.Label().reference(),
                "url": MenuItem.Schemas.URL().reference(),
                "priority": MenuItem.Schemas.Priority().reference(),
                "isBlank": MenuItem.Schemas.IsBlank().reference(),
                "permission": MenuItem.Schemas.Permission().reference(),
                "authentication": MenuItem.Schemas.Authentication().reference(),
                "createdAt": MenuItem.Schemas.CreatedAt().reference(),
                "updatedAt": MenuItem.Schemas.UpdatedAt().reference(),
            ]
        }
    }
}
