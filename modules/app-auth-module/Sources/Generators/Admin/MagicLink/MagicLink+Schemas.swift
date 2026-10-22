import FeatherOpenAPI
import OpenAPIKit30

extension MagicLink.Schemas {

    struct AuthMagicLinkIdField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkIdField" }
        var example: String? = "uml_k3P9qN2v"
    }
}

extension MagicLink.Schemas {

    struct AuthMagicLinkCredentialIdField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkCredentialIdField" }
        var example: String? = "cred_k3P9qN2v"
    }
}

extension MagicLink.Schemas {

    struct AuthMagicLinkTokenField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkTokenField" }
        var example: String? = "mgl_3XbY..."
    }
}

extension MagicLink.Schemas {

    struct AuthMagicLinkExpiresAtField: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkExpiresAtField" }
        var example: Double? { 1_760_000_000 }
    }
}

extension MagicLink.Schemas {

    struct AuthMagicLinkIsUsedField: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkIsUsedField" }
        var example: Bool? = false
    }
}

extension MagicLink.Schemas {

    struct AuthMagicLinkIsPersistentField: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkIsPersistentField" }
        var example: Bool? = true
    }
}

extension MagicLink.Schemas {

    struct AuthMagicLinkUpdateMaskField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkUpdateMaskField" }
        var example: String? = "credentialId,isPersistent"
    }
}

extension MagicLink.Query.Schemas {

    struct AuthMagicLinkUserIdField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkUserIdField" }
    }
}

extension MagicLink.Schemas {

    struct AuthMagicLinkCreateSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "credentialId": MagicLink.Schemas
                    .AuthMagicLinkCredentialIdField(),
                "isPersistent": MagicLink.Schemas
                    .AuthMagicLinkIsPersistentField(),
            ]
        }
    }
}

extension MagicLink.Schemas {

    struct AuthMagicLinkPatchSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "credentialId": MagicLink.Schemas
                    .AuthMagicLinkCredentialIdField()
                    .reference(required: false),
                "isPersistent": MagicLink.Schemas
                    .AuthMagicLinkIsPersistentField()
                    .reference(required: false),
            ]
        }
    }
}

extension MagicLink.Schemas {

    struct AuthMagicLinkDetailSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": MagicLink.Schemas.AuthMagicLinkIdField(),
                "credentialId": MagicLink.Schemas
                    .AuthMagicLinkCredentialIdField(),
                "token": MagicLink.Schemas.AuthMagicLinkTokenField(),
                "expiresAt": MagicLink.Schemas.AuthMagicLinkExpiresAtField(),
                "isPersistent": MagicLink.Schemas
                    .AuthMagicLinkIsPersistentField(),
                "isUsed": MagicLink.Schemas.AuthMagicLinkIsUsedField(),
            ]
        }
    }
}

extension MagicLink.Schemas {

    struct AuthMagicLinkListItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkListItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": MagicLink.Schemas.AuthMagicLinkIdField().reference(),
                "credentialId": MagicLink.Schemas
                    .AuthMagicLinkCredentialIdField().reference(),
                "token": MagicLink.Schemas.AuthMagicLinkTokenField()
                    .reference(),
                "expiresAt": MagicLink.Schemas.AuthMagicLinkExpiresAtField()
                    .reference(),
                "isPersistent": MagicLink.Schemas
                    .AuthMagicLinkIsPersistentField().reference(),
                "isUsed": MagicLink.Schemas.AuthMagicLinkIsUsedField()
                    .reference(),
            ]
        }
    }
}

extension MagicLink.Query.Schemas {

    struct AuthMagicLinkQueryItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": MagicLink.Schemas.AuthMagicLinkIdField().reference(),
                "credentialId": MagicLink.Schemas
                    .AuthMagicLinkCredentialIdField().reference(),
                "token": MagicLink.Schemas.AuthMagicLinkTokenField()
                    .reference(),
                "expiresAt": MagicLink.Schemas.AuthMagicLinkExpiresAtField()
                    .reference(),
                "isPersistent": MagicLink.Schemas
                    .AuthMagicLinkIsPersistentField().reference(),
                "isUsed": MagicLink.Schemas.AuthMagicLinkIsUsedField()
                    .reference(),
            ]
        }
    }
}

extension MagicLink.Schemas {

    struct AuthMagicLinkListSchema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkListSchema" }
        var items: (any SchemaRepresentable)? {
            MagicLink.Schemas.AuthMagicLinkListItemSchema().reference()
        }
    }
}
