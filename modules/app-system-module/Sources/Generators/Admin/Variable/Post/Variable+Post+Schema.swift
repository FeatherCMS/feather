import FeatherOpenAPI

extension Variable.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Variable.Schemas.Key(),
                "value": Variable.Schemas.Value(),
                "name": Variable.Schemas.Name().reference(required: false),
                "notes": Variable.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
