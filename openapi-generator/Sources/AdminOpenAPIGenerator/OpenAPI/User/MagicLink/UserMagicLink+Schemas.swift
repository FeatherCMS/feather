import FeatherOpenAPI
import OpenAPIKit30

struct UserMagicLinkIdField: StringSchemaRepresentable {
    var example: String? = "uml_k3P9qN2v"
}

struct UserMagicLinkEmailField: StringSchemaRepresentable {
    var example: String? = "admin@example.com"
}

struct UserMagicLinkTokenField: StringSchemaRepresentable {
    var example: String? = "mgl_3XbY..."
}

struct UserMagicLinkExpiresAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct UserMagicLinkIsUsedField: BoolSchemaRepresentable {
    var example: Bool? = false
}

struct UserMagicLinkIsPersistentField: BoolSchemaRepresentable {
    var example: Bool? = true
}

struct UserMagicLinkCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": UserMagicLinkEmailField(),
            "isPersistent": UserMagicLinkIsPersistentField(),
        ]
    }
}

struct UserMagicLinkPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": UserMagicLinkEmailField().reference(required: false),
            "isPersistent": UserMagicLinkIsPersistentField()
                .reference(required: false),
        ]
    }
}

struct UserMagicLinkDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserMagicLinkIdField(),
            "email": UserMagicLinkEmailField(),
            "token": UserMagicLinkTokenField(),
            "expiresAt": UserMagicLinkExpiresAtField(),
            "isPersistent": UserMagicLinkIsPersistentField(),
            "isUsed": UserMagicLinkIsUsedField(),
        ]
    }
}

struct UserMagicLinkListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserMagicLinkIdField().reference(),
            "email": UserMagicLinkEmailField().reference(),
            "token": UserMagicLinkTokenField().reference(),
            "expiresAt": UserMagicLinkExpiresAtField().reference(),
            "isPersistent": UserMagicLinkIsPersistentField().reference(),
            "isUsed": UserMagicLinkIsUsedField().reference(),
        ]
    }
}

struct UserMagicLinkListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        UserMagicLinkListItemSchema().reference()
    }
}
