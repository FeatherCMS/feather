import FeatherOpenAPI

extension Menu.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MenuCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Menu.Schemas.Key(),
                "name": Menu.Schemas.Name(),
                "notes": Menu.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
