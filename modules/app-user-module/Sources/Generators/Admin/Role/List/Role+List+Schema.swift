import FeatherOpenAPI

extension Role.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleListSchema" }
        var items: (any SchemaRepresentable)? {
            ItemSchema().reference()
        }
    }

    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleListItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Role.Schemas.ID().reference(),
                "key": Role.Schemas.Key().reference(),
                "name": Role.Schemas.Name().reference(required: false),
            ]
        }
    }
}
