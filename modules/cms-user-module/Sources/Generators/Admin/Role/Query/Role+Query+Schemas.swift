import FeatherOpenAPI

extension Role.Query {
    enum Schemas {}
}

extension Role.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Role.Schemas.ID().reference(),
                "key": Role.Schemas.Key().reference(),
                "name": Role.Schemas.Name().reference(required: false),
                "notes": Role.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
