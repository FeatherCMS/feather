import FeatherOpenAPI

extension MenuItem.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": MenuItem.Schemas.ID(),
                "menuId": Menu.Schemas.ID(),
                "label": MenuItem.Schemas.Label(),
                "url": MenuItem.Schemas.URL(),
                "priority": MenuItem.Schemas.Priority(),
                "isBlank": MenuItem.Schemas.IsBlank(),
                "permission": MenuItem.Schemas.Permission(),
                "authentication": MenuItem.Schemas.Authentication(),
                "notes": MenuItem.Schemas.Notes().reference(required: false),
                "createdAt": MenuItem.Schemas.CreatedAt(),
                "updatedAt": MenuItem.Schemas.UpdatedAt(),
            ]
        }
    }
}
