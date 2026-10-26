import FeatherOpenAPI

extension MagicLink.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "credentialId": MagicLink.Schemas
                    .CredentialID()
                    .reference(required: false),
                "isPersistent": MagicLink.Schemas
                    .IsPersistent()
                    .reference(required: false),
            ]
        }
    }
}
