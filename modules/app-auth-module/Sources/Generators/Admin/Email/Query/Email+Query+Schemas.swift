import FeatherOpenAPI
import OpenAPIKit30

extension Email.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailQuerySchemasItem" }
        var propertyMap: SchemaMap {
            [
                "id": Email.Schemas.IDField().reference(),
                "identityId": Email.Schemas.IdentityIDField().reference(),
                "email": Email.Schemas.EmailField().reference(),
            ]
        }
    }
}
