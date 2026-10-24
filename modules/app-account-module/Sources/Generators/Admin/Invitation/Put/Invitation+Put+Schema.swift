import FeatherOpenAPI

extension Invitation.Put {
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
