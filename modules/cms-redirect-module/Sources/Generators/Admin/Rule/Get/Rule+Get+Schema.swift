import FeatherOpenAPI

extension Rule.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Rule.Schemas.ID(),
                "source": Rule.Schemas.Source(),
                "destination": Rule.Schemas.Destination(),
                "statusCode": Rule.Schemas.StatusCode(),
                "notes": Rule.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
