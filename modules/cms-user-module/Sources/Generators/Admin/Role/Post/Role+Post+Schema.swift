import FeatherOpenAPI

extension Role.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Role.Schemas.Key().reference(),
                "name": Role.Schemas.Name().reference(required: false),
                "notes": Role.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
