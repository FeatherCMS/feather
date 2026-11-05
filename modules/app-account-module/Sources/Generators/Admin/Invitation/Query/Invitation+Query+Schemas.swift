import FeatherOpenAPI

extension Invitation.Query {
    enum Schemas {}
}

extension Invitation.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": Invitation.Schemas.ID().reference(),
                "email": Invitation.Schemas.Email().reference(),
                "token": Invitation.Schemas.Token().reference(),
                "roleIds": Invitation.Schemas.RoleIDs().reference(),
                "expiresAt": Invitation.Schemas.ExpiresAt().reference(),
            ]
        }
    }
}
