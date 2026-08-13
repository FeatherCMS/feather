import FeatherOpenAPI
import OpenAPIKit30

struct AppNewsletterIdField: StringSchemaRepresentable {}
struct AppNewsletterEmailField: StringSchemaRepresentable {}
struct AppNewsletterNameField: StringSchemaRepresentable {}
struct AppNewsletterContentField: StringSchemaRepresentable {}
struct AppNewsletterBooleanField: BoolSchemaRepresentable {}
struct AppNewsletterPositionField: IntSchemaRepresentable {}
struct AppNewsletterJSONField: SchemaRepresentable {
    func openAPISchema() -> JSONSchema {
        .object(
            format: .generic,
            required: required,
            nullable: nullable,
            permissions: nil,
            deprecated: deprecated,
            title: title,
            description: description,
            discriminator: nil,
            externalDocs: nil,
            minProperties: nil,
            maxProperties: nil,
            properties: [:],
            additionalProperties: .schema(JSONSchema.string),
            allowedValues: nil,
            defaultValue: nil,
            example: nil
        )
    }
}
struct AppNewsletterCampaignSubscriptionSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": AppNewsletterEmailField(),
            "firstName": AppNewsletterNameField().reference(required: false),
            "lastName": AppNewsletterNameField().reference(required: false),
        ]
    }
}
