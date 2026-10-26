import FeatherOpenAPI

extension Identity.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "name": Identity.Schemas.Name().reference(),
                "status": Identity.Schemas.Status().reference(required: false),
                "roleIds": Identity.Schemas.RoleIDs()
                    .reference(
                        required: false
                    ),
            ]
        }
    }
}
