import FeatherOpenAPI
import OpenAPIKit30

extension MagicLink.Query {
    enum Schemas {}
}

extension MagicLink.Query.Schemas {
    struct UserID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkUserIdField" }
    }
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkQueryItemSchema" }
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
}
