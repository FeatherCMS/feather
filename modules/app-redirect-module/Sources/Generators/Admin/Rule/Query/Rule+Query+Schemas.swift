import FeatherOpenAPI

extension Rule.Query {
    enum Schemas {}
}

extension Rule.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Rule.Schemas.ID().reference(),
                "source": Rule.Schemas.Source().reference(),
                "destination": Rule.Schemas.Destination().reference(),
                "statusCode": Rule.Schemas.StatusCode().reference(),
            ]
        }
    }

    struct Filters: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleFiltersSchema" }
        var propertyMap: SchemaMap {
            [
                "search": Rule.Schemas.Search().reference(required: false),
                "statusCode": Rule.Schemas.StatusCode()
                    .reference(required: false),
            ]
        }
    }
}
