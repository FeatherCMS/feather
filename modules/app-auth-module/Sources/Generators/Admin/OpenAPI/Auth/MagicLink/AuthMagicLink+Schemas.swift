import FeatherOpenAPI
import OpenAPIKit30

struct AuthMagicLinkIdField: StringSchemaRepresentable {
    var example: String? = "uml_k3P9qN2v"
}

struct AuthMagicLinkCredentialIdField: StringSchemaRepresentable {
    var example: String? = "cred_k3P9qN2v"
}

struct AuthMagicLinkTokenField: StringSchemaRepresentable {
    var example: String? = "mgl_3XbY..."
}

struct AuthMagicLinkExpiresAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct AuthMagicLinkIsUsedField: BoolSchemaRepresentable {
    var example: Bool? = false
}

struct AuthMagicLinkIsPersistentField: BoolSchemaRepresentable {
    var example: Bool? = true
}

struct AuthMagicLinkCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "credentialId": AuthMagicLinkCredentialIdField(),
            "isPersistent": AuthMagicLinkIsPersistentField(),
        ]
    }
}

struct AuthMagicLinkPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "credentialId": AuthMagicLinkCredentialIdField()
                .reference(required: false),
            "isPersistent": AuthMagicLinkIsPersistentField()
                .reference(required: false),
        ]
    }
}

struct AuthMagicLinkDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": AuthMagicLinkIdField(),
            "credentialId": AuthMagicLinkCredentialIdField(),
            "token": AuthMagicLinkTokenField(),
            "expiresAt": AuthMagicLinkExpiresAtField(),
            "isPersistent": AuthMagicLinkIsPersistentField(),
            "isUsed": AuthMagicLinkIsUsedField(),
        ]
    }
}

struct AuthMagicLinkListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": AuthMagicLinkIdField().reference(),
            "credentialId": AuthMagicLinkCredentialIdField().reference(),
            "token": AuthMagicLinkTokenField().reference(),
            "expiresAt": AuthMagicLinkExpiresAtField().reference(),
            "isPersistent": AuthMagicLinkIsPersistentField().reference(),
            "isUsed": AuthMagicLinkIsUsedField().reference(),
        ]
    }
}

struct AuthMagicLinkListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        AuthMagicLinkListItemSchema().reference()
    }
}
