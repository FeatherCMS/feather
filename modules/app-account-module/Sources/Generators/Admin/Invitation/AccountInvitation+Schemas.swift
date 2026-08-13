import FeatherOpenAPI
import OpenAPIKit30

struct AccountInvitationIdField: StringSchemaRepresentable {
    var example: String? = "inv_7nL3xQ2v"
}

struct AccountInvitationEmailField: StringSchemaRepresentable {
    var example: String? = "john.doe@example.com"
}

struct AccountInvitationTokenField: StringSchemaRepresentable {
    var example: String? = "eyJhbGciOi..."
}

struct AccountInvitationRoleIDsField: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        AccountInvitationRoleIDField()
    }
}

struct AccountInvitationRoleIDField: StringSchemaRepresentable {}

struct AccountInvitationExpiresAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct AccountInvitationCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": AccountInvitationEmailField(),
            "roleIds": AccountInvitationRoleIDsField()
                .reference(required: false),
        ]
    }
}

struct AccountInvitationPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": AccountInvitationEmailField().reference(required: false)
        ]
    }
}

struct AccountInvitationDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": AccountInvitationIdField(),
            "email": AccountInvitationEmailField(),
            "token": AccountInvitationTokenField(),
            "expiresAt": AccountInvitationExpiresAtField(),
        ]
    }
}

struct AccountInvitationListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": AccountInvitationIdField().reference(),
            "email": AccountInvitationEmailField().reference(),
            "token": AccountInvitationTokenField().reference(),
            "expiresAt": AccountInvitationExpiresAtField().reference(),
        ]
    }
}

struct AccountInvitationListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        AccountInvitationListItemSchema().reference()
    }
}
