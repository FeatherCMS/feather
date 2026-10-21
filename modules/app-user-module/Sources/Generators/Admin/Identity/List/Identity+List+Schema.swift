import FeatherOpenAPI
import UserOpenAPIGeneratorSupport

extension Identity.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityListSchema" }
        var items: (any SchemaRepresentable)? {
            ItemSchema().reference()
        }
    }

    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityListItemSchema" }
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
