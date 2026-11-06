import FeatherOpenAPI

extension Credential.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Credential.Schemas.ID(),
                "userId": Credential.Schemas.UserID(),
                "email": Credential.Schemas.Email(),
            ]
        }
    }
}
