import FeatherOpenAPI

extension Rule.Schemas {
    struct Create: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "source": Source(),
                "destination": Destination(),
                "statusCode": StatusCode(),
                "notes": Notes().reference(required: false),
            ]
        }
    }
}
