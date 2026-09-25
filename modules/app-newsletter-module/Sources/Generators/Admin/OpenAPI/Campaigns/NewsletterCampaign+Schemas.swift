import FeatherOpenAPI
import OpenAPIKit30

struct NewsletterIdField: StringSchemaRepresentable {}
struct NewsletterKeyField: StringSchemaRepresentable {}
struct NewsletterNameField: StringSchemaRepresentable {}
struct NewsletterEmailField: StringSchemaRepresentable {}
struct NewsletterTimestampField: DoubleSchemaRepresentable {}

struct NewsletterJSONField: SchemaRepresentable {
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

struct NewsletterCampaignSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "key": NewsletterKeyField(),
            "name": NewsletterNameField(),
            "fromEmail": NewsletterEmailField(),
            "createdAt": NewsletterTimestampField(),
            "updatedAt": NewsletterTimestampField(),
        ]
    }
}

struct NewsletterCampaignListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { NewsletterCampaignSchema().reference() }
}
struct NewsletterCampaignCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "key": NewsletterKeyField(),
            "name": NewsletterNameField(),
            "fromEmail": NewsletterEmailField(),
        ]
    }
}
struct NewsletterCampaignPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "key": NewsletterKeyField().reference(required: false),
            "name": NewsletterNameField().reference(required: false),
            "fromEmail": NewsletterEmailField().reference(required: false),
        ]
    }
}
