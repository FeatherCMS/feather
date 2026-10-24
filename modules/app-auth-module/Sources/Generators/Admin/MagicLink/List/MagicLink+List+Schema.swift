import FeatherOpenAPI

extension MagicLink.List {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkListItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": MagicLink.Schemas.ID().reference(),
                "credentialId": MagicLink.Schemas
                    .CredentialID().reference(),
                "token": MagicLink.Schemas.Token()
                    .reference(),
                "expiresAt": MagicLink.Schemas.ExpiresAt()
                    .reference(),
                "isPersistent": MagicLink.Schemas
                    .IsPersistent().reference(),
                "isUsed": MagicLink.Schemas.IsUsed()
                    .reference(),
            ]
        }
    }
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkListSchema" }
        var items: (any SchemaRepresentable)? {
            MagicLink.List.Item().reference()
        }
    }
}
