import FeatherOpenAPI

extension Permission.List {

    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionListSchema" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }

    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionListItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Permission.Schemas.ID().reference(),
                "key": Permission.Schemas.Key().reference(),
                "name": Permission.Schemas.Name().reference(required: false),
                "notes": Permission.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
