import FeatherOpenAPI
import OpenAPIKit30

extension Rule.List {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleListItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Rule.Schemas.ID().reference(),
                "source": Rule.Schemas.Source().reference(),
                "destination": Rule.Schemas.Destination().reference(),
                "statusCode": Rule.Schemas.StatusCode().reference(),
            ]
        }
    }

    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleListSchema" }
        var items: (any SchemaRepresentable)? { Item().reference() }
    }
}
