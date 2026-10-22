import FeatherOpenAPI
import UserOpenAPIGeneratorSupport

extension Identity.Query {
    enum Schemas {}
}

extension Identity.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": IdentityIDField().reference(),
                "name": IdentityNameField().reference(),
                "status": IdentityStatusField().reference(),
                "roles": Identity.Schemas.RoleNames().reference(),
            ]
        }
    }
}
