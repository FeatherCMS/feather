import FeatherOpenAPI

extension Role.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Role.Schemas.ID(),
                "key": Role.Schemas.Key(),
                "name": Role.Schemas.Name().reference(required: false),
                "notes": Role.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
