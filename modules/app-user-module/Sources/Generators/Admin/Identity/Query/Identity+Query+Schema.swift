import FeatherOpenAPI
import UserOpenAPIGeneratorSupport

extension Identity.Query {
    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": UserIdentityIDField().reference(),
                "name": UserIdentityNameField().reference(),
                "status": UserIdentityStatusField().reference(),
                "roles": Identity.Schemas.RoleNames().reference(),
            ]
        }
    }
}
