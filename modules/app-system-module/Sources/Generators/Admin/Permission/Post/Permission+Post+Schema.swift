import FeatherOpenAPI

extension Permission.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Permission.Schemas.Key(),
                "name": Permission.Schemas.Name().reference(required: false),
                "notes": Permission.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
