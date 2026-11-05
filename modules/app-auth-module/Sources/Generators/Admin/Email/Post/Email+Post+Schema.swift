import FeatherOpenAPI

extension Email.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasCreate" }
        var propertyMap: SchemaMap {
            [
                "identityId": Email.Schemas.IdentityIDField().reference(),
                "email": Email.Schemas.EmailField().reference(),
            ]
        }
    }
}
