import FeatherOpenAPI

extension Rule.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleSchema" }
        var propertyMap: SchemaMap {
            [
                "source": Rule.Schemas.Source().reference(),
                "destination": Rule.Schemas.Destination().reference(),
                "statusCode": Rule.Schemas.StatusCode().reference(),
            ]
        }
    }
}
