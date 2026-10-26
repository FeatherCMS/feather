import FeatherOpenAPI

extension Menu.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "MenuListSchema" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }

    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MenuListItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Menu.Schemas.ID().reference(),
                "key": Menu.Schemas.Key().reference(),
                "name": Menu.Schemas.Name().reference(),
                "createdAt": Menu.Schemas.CreatedAt().reference(),
                "updatedAt": Menu.Schemas.UpdatedAt().reference(),
            ]
        }
    }
}
