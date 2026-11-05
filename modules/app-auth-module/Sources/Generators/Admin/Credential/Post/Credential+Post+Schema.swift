import FeatherOpenAPI

extension Credential.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "userId": Credential.Schemas.UserID(),
                "email": Credential.Schemas.Email(),
                "password": Credential.Schemas.Password(),
            ]
        }
    }
}
