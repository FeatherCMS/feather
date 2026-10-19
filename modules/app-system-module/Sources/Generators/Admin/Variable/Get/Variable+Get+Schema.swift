import FeatherOpenAPI
import OpenAPIKit30

extension Variable.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Variable.Schemas.ID().reference(),
                "key": Variable.Schemas.Key(),
                "value": Variable.Schemas.Value(),
                "name": Variable.Schemas.Name().reference(required: false),
                "notes": Variable.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
