import FeatherOpenAPI

extension Permission.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Permission.Schemas.ID().reference(),
                "key": Permission.Schemas.Key(),
                "name": Permission.Schemas.Name().reference(required: false),
                "notes": Permission.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
