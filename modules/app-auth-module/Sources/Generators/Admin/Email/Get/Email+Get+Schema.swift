import FeatherOpenAPI
import OpenAPIKit30

extension Email.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasDetail" }
        var propertyMap: SchemaMap {
            [
                "id": Email.Schemas.IDField().reference(),
                "identityId": Email.Schemas.IdentityIDField().reference(),
                "email": Email.Schemas.EmailField().reference(),
            ]
        }
    }
}
