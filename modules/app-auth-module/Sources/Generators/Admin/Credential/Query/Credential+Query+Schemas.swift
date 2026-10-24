import FeatherOpenAPI

extension Credential.Query {
    enum Schemas {}
}

extension Credential.Query.Schemas {
    struct Search: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialQueryField" }
        var example: String? = "foo"
    }
    struct Filter: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialQueryFilterSchema" }
        var propertyMap: SchemaMap {
            [
                "search": Credential.Query.Schemas.Search()
                    .reference(required: false),
                "userId": Credential.Schemas.UserID()
                    .reference(required: false),
            ]
        }

        var example: AnyCodable? {
            AnyCodable(["search": "foo", "userId": "user_7nL3xQ2v"])
        }
    }
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Credential.Schemas.ID().reference(),
                "userId": Credential.Schemas.UserID()
                    .reference(),
                "identityName": Credential.Schemas
                    .IdentityName().reference(),
                "email": Credential.Schemas.Email()
                    .reference(),
            ]
        }
    }
}
