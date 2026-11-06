import FeatherOpenAPI

extension Invitation.Post {
    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "email": Invitation.Schemas.Email(),
                "roleIds": Invitation.Schemas.RoleIDs()
                    .reference(required: false),
            ]
        }
    }
}
