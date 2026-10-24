import FeatherOpenAPI
import OpenAPIKit30

extension MagicLink.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "credentialId": MagicLink.Schemas
                    .CredentialID(),
                "isPersistent": MagicLink.Schemas
                    .IsPersistent(),
            ]
        }
    }
}
