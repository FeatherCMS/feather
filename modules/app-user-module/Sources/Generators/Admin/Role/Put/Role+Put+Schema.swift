import FeatherOpenAPI

extension Role.Put {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleUpdateSchema" }
        var propertyMap: SchemaMap {
            [
                "name": Role.Schemas.Name().reference(required: false),
                "notes": Role.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
