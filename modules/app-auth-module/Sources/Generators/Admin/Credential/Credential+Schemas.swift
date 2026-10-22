import FeatherOpenAPI
import OpenAPIKit30

extension Credential.Schemas {

    struct AuthCredentialIdField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialIdField" }
        var example: String? = "credential_7nL3xQ2v"
    }
}

extension Credential.Schemas {

    struct AuthCredentialUserIdField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialUserIdField" }
        var example: String? = "user_7nL3xQ2v"
    }
}

extension Credential.Schemas {

    struct AuthCredentialEmailField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialEmailField" }
        var example: String? = "john.doe@example.com"
    }
}

extension Credential.Schemas {

    struct AuthCredentialPasswordField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialPasswordField" }
        var example: String? = "correct-horse-battery-staple"
        var format: String? = "password"
    }
}

extension Credential.Schemas {

    struct AuthCredentialUpdateMaskField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialUpdateMaskField" }
        var example: String? = "userId,email,password"
    }
}

extension Credential.Query.Schemas {

    struct AuthCredentialQueryField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialQueryField" }
        var example: String? = "foo"
    }
}

extension Credential.Query.Schemas {

    struct AuthCredentialQueryFilterSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialQueryFilterSchema" }
        var propertyMap: SchemaMap {
            [
                "search": Credential.Query.Schemas.AuthCredentialQueryField()
                    .reference(required: false),
                "userId": Credential.Schemas.AuthCredentialUserIdField()
                    .reference(required: false),
            ]
        }

        var example: AnyCodable? {
            AnyCodable(["search": "foo", "userId": "user_7nL3xQ2v"])
        }
    }
}

extension Credential.Schemas {

    struct AuthCredentialCreateSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "userId": Credential.Schemas.AuthCredentialUserIdField(),
                "email": Credential.Schemas.AuthCredentialEmailField(),
                "password": Credential.Schemas.AuthCredentialPasswordField(),
            ]
        }
    }
}

extension Credential.Schemas {

    struct AuthCredentialPatchSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "userId": Credential.Schemas.AuthCredentialUserIdField()
                    .reference(required: false),
                "email": Credential.Schemas.AuthCredentialEmailField()
                    .reference(required: false),
                "password": Credential.Schemas.AuthCredentialPasswordField()
                    .reference(required: false),
            ]
        }
    }
}

extension Credential.Schemas {

    struct AuthCredentialDetailSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Credential.Schemas.AuthCredentialIdField(),
                "userId": Credential.Schemas.AuthCredentialUserIdField(),
                "email": Credential.Schemas.AuthCredentialEmailField(),
            ]
        }
    }
}

extension Credential.Schemas {

    struct AuthCredentialListItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialListItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Credential.Schemas.AuthCredentialIdField().reference(),
                "userId": Credential.Schemas.AuthCredentialUserIdField()
                    .reference(),
                "identityName": Credential.Schemas
                    .AuthCredentialIdentityNameField().reference(),
                "email": Credential.Schemas.AuthCredentialEmailField()
                    .reference(),
            ]
        }
    }
}

extension Credential.Query.Schemas {

    struct AuthCredentialQueryItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Credential.Schemas.AuthCredentialIdField().reference(),
                "userId": Credential.Schemas.AuthCredentialUserIdField()
                    .reference(),
                "identityName": Credential.Schemas
                    .AuthCredentialIdentityNameField().reference(),
                "email": Credential.Schemas.AuthCredentialEmailField()
                    .reference(),
            ]
        }
    }
}

extension Credential.Schemas {

    struct AuthCredentialIdentityNameField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialIdentityNameField" }
        var example: String? = "Root User"
    }
}

extension Credential.Schemas {

    struct AuthCredentialListSchema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialListSchema" }
        var items: (any SchemaRepresentable)? {
            Credential.Schemas.AuthCredentialListItemSchema().reference()
        }
    }
}
