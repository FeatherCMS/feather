import FeatherOpenAPI
import OpenAPIKit30

extension Variable.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableListSchema" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }

    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableListItemSchema" }
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
