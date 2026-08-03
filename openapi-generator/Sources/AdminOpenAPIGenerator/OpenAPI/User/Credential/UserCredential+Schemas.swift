import FeatherOpenAPI
import OpenAPIKit30

struct UserCredentialIdField: StringSchemaRepresentable {
    var example: String? = "credential_7nL3xQ2v"
}

struct UserCredentialAccountIdField: StringSchemaRepresentable {
    var example: String? = "account_7nL3xQ2v"
}

struct UserCredentialEmailField: StringSchemaRepresentable {
    var example: String? = "john.doe@example.com"
}

struct UserCredentialPasswordField: StringSchemaRepresentable {
    var example: String? = "correct-horse-battery-staple"
    var format: String? = "password"
}

struct UserCredentialSearchField: StringSchemaRepresentable {
    var example: String? = "foo"
}

struct UserCredentialSearchFilterSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "search": UserCredentialSearchField().reference(required: false),
            "accountID": UserCredentialAccountIdField()
                .reference(required: false),
        ]
    }
}

struct UserCredentialCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "accountID": UserCredentialAccountIdField(),
            "email": UserCredentialEmailField(),
            "password": UserCredentialPasswordField(),
        ]
    }
}

struct UserCredentialPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": UserCredentialEmailField().reference(required: false),
            "password": UserCredentialPasswordField()
                .reference(required: false),
        ]
    }
}

struct UserCredentialDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserCredentialIdField(),
            "accountID": UserCredentialAccountIdField(),
            "email": UserCredentialEmailField(),
        ]
    }
}

struct UserCredentialListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserCredentialIdField().reference(),
            "accountID": UserCredentialAccountIdField().reference(),
            "email": UserCredentialEmailField().reference(),
        ]
    }
}

struct UserCredentialListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        UserCredentialListItemSchema().reference()
    }
}
