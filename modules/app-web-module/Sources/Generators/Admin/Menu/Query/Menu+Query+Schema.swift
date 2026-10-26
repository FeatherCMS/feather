import FeatherOpenAPI

extension Menu.Query {
    enum Schemas {}
}

extension Menu.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MenuQueryItemSchema" }
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
