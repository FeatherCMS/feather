import FeatherOpenAPI

extension Identity.Put {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityUpdateSchema" }
        var propertyMap: SchemaMap {
            [
                "name": Identity.Schemas.Name().reference(required: false),
                "status": Identity.Schemas.Status().reference(required: false),
                "roleIds": Identity.Schemas.RoleIDs()
                    .reference(
                        required: false
                    ),
            ]
        }
    }
}
