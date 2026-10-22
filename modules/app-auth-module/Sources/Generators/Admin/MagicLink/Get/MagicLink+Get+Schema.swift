import FeatherOpenAPI
import OpenAPIKit30

extension MagicLink.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": MagicLink.Schemas.ID(),
                "credentialId": MagicLink.Schemas
                    .CredentialID(),
                "token": MagicLink.Schemas.Token(),
                "expiresAt": MagicLink.Schemas.ExpiresAt(),
                "isPersistent": MagicLink.Schemas
                    .IsPersistent(),
                "isUsed": MagicLink.Schemas.IsUsed(),
            ]
        }
    }
}
