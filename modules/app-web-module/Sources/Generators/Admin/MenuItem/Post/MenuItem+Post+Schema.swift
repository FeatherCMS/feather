import FeatherOpenAPI

extension MenuItem.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "label": MenuItem.Schemas.Label(),
                "url": MenuItem.Schemas.URL(),
                "priority": MenuItem.Schemas.Priority(),
                "isBlank": MenuItem.Schemas.IsBlank(),
                "permission": MenuItem.Schemas.Permission(),
                "authentication": MenuItem.Schemas.Authentication()
                    .reference(required: false),
                "notes": MenuItem.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
