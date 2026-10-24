import FeatherOpenAPI

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
                "id": Identity.Schemas.ID().reference(),
                "name": Identity.Schemas.Name().reference(),
                "status": Identity.Schemas.Status().reference(),
                "roles": Identity.Schemas.RoleNames().reference(),
            ]
        }
    }
}
