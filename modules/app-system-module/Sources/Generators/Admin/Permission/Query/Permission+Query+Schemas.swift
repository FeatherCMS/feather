import FeatherOpenAPI

extension Permission.Query {
    enum Schemas {}
}

extension Permission.Query.Schemas {

    struct Filter: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionIDsFilter" }
        var items: (any SchemaRepresentable)? { Permission.Schemas.ID() }
        var required: Bool { false }
    }

    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionQueryItemSchema" }
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
