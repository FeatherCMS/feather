import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Rule.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRulePatchSchema" }
        var propertyMap: SchemaMap {
            [
                "source": Rule.Schemas.Source().reference(required: false),
                "destination": Rule.Schemas.Destination()
                    .reference(required: false),
                "statusCode": Rule.Schemas.StatusCode()
                    .reference(required: false),
                "notes": Rule.Schemas.Notes().nullable()
                    .reference(required: false),
            ]
        }
    }
}
