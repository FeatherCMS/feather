import FeatherOpenAPI
import OpenAPIKit30

extension Credential.List {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialListItemSchema" }
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
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialListSchema" }
        var items: (any SchemaRepresentable)? {
            Credential.List.Item().reference()
        }
    }
}
