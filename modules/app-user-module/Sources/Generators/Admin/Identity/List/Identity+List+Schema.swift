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
                "id": IdentityIDField().reference(),
                "name": IdentityNameField().reference(),
                "status": IdentityStatusField().reference(),
                "roles": Identity.Schemas.RoleNames().reference(),
            ]
        }
    }
}
