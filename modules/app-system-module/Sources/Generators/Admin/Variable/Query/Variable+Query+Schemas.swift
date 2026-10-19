import FeatherOpenAPI

extension Variable.Query.Schemas {
    struct Filter: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableIDsFilter" }
        var items: (any SchemaRepresentable)? { Variable.Schemas.ID() }
        var required: Bool { false }
    }

    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Variable.Schemas.ID().reference(),
                "key": Variable.Schemas.Key().reference(),
                "value": Variable.Schemas.Value().reference(),
                "name": Variable.Schemas.Name().reference(required: false),
                "notes": Variable.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
