import FeatherOpenAPI
import OpenAPIKit30

struct AuthCredentialIdField: StringSchemaRepresentable {
    var example: String? = "credential_7nL3xQ2v"
}

struct AuthCredentialUserIdField: StringSchemaRepresentable {
    var example: String? = "user_7nL3xQ2v"
}

struct AuthCredentialEmailField: StringSchemaRepresentable {
    var example: String? = "john.doe@example.com"
}

struct AuthCredentialPasswordField: StringSchemaRepresentable {
    var example: String? = "correct-horse-battery-staple"
    var format: String? = "password"
}

struct AuthCredentialSearchField: StringSchemaRepresentable {
    var example: String? = "foo"
}

struct AuthCredentialSearchFilterSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "search": AuthCredentialSearchField().reference(required: false),
            "userId": AuthCredentialUserIdField()
                .reference(required: false),
        ]
    }
}

struct AuthCredentialCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "userId": AuthCredentialUserIdField(),
            "email": AuthCredentialEmailField(),
            "password": AuthCredentialPasswordField(),
        ]
    }
}

struct AuthCredentialPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": AuthCredentialEmailField().reference(required: false),
            "password": AuthCredentialPasswordField()
                .reference(required: false),
        ]
    }
}

struct AuthCredentialDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": AuthCredentialIdField(),
            "userId": AuthCredentialUserIdField(),
            "email": AuthCredentialEmailField(),
        ]
    }
}

struct AuthCredentialListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": AuthCredentialIdField().reference(),
            "userId": AuthCredentialUserIdField().reference(),
            "email": AuthCredentialEmailField().reference(),
        ]
    }
}

struct AuthCredentialListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        AuthCredentialListItemSchema().reference()
    }
}
