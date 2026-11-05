import FeatherOpenAPI

extension Invitation.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "email": Invitation.Schemas.Email().reference(required: false),
                "roleIds": Invitation.Schemas.RoleIDs()
                    .reference(required: false),
            ]
        }
    }
}
