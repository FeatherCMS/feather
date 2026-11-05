import FeatherOpenAPI

extension Invitation.List {
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

    struct Schema: ArraySchemaRepresentable {
        var items: (any SchemaRepresentable)? { Item().reference() }
    }
}
