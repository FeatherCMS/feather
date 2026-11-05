import FeatherOpenAPI

extension Menu.ID.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MenuDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Menu.Schemas.ID(),
                "key": Menu.Schemas.Key(),
                "name": Menu.Schemas.Name(),
                "notes": Menu.Schemas.Notes().reference(required: false),
                "createdAt": Menu.Schemas.CreatedAt(),
                "updatedAt": Menu.Schemas.UpdatedAt(),
            ]
        }
    }
}
