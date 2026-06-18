import FeatherOpenAPI
import OpenAPIKit30

struct UserInvitationIdField: StringSchemaRepresentable {
    var example: String? = "inv_7nL3xQ2v"
}

struct UserInvitationEmailField: StringSchemaRepresentable {
    var example: String? = "john.doe@example.com"
}

struct UserInvitationTokenField: StringSchemaRepresentable {
    var example: String? = "eyJhbGciOi..."
}

struct UserInvitationExpiresAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct UserInvitationCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": UserInvitationEmailField()
        ]
    }
}

struct UserInvitationPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": UserInvitationEmailField().reference(required: false)
        ]
    }
}

struct UserInvitationDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserInvitationIdField(),
            "email": UserInvitationEmailField(),
            "token": UserInvitationTokenField(),
            "expiresAt": UserInvitationExpiresAtField(),
        ]
    }
}

struct UserInvitationListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserInvitationIdField().reference(),
            "email": UserInvitationEmailField().reference(),
            "token": UserInvitationTokenField().reference(),
            "expiresAt": UserInvitationExpiresAtField().reference(),
        ]
    }
}

struct UserInvitationListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        UserInvitationListItemSchema().reference()
    }
}
