import FeatherOpenAPI
import OpenAPIKit30

struct ContactAllowedValuesSchema: ArraySchemaRepresentable { var items: SchemaRepresentable? { AppContactNameField() } }

struct AppContactIdField: StringSchemaRepresentable {}
struct AppContactEmailField: StringSchemaRepresentable {}
struct AppContactNameField: StringSchemaRepresentable {}
struct AppContactContentField: StringSchemaRepresentable {}
struct AppContactBooleanField: BoolSchemaRepresentable {}
struct AppContactPositionField: IntSchemaRepresentable {}
struct AppContactJSONField: SchemaRepresentable {
    func openAPISchema() -> JSONSchema {
        .object(format: .generic, required: required, nullable: nullable, permissions: nil, deprecated: deprecated, title: title, description: description, discriminator: nil, externalDocs: nil, minProperties: nil, maxProperties: nil, properties: [:], additionalProperties: .schema(JSONSchema.string), allowedValues: nil, defaultValue: nil, example: nil)
    }
}
struct AppContactFormItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": AppContactIdField(),
            "key": AppContactIdField(),
            "type": AppContactIdField(),
            "label": AppContactNameField(),
            "allowedValues": ContactAllowedValuesSchema().reference(required: false),
            "isRequired": AppContactBooleanField(),
            "position": AppContactPositionField()
        ]
    }
}
struct AppContactFormItemsSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { AppContactFormItemSchema().reference() }
}
struct AppContactFormSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        ["id": AppContactIdField(), "name": AppContactNameField(), "successMessage": AppContactContentField(), "failureMessage": AppContactContentField(), "redirectUrl": AppContactContentField().reference(required: false), "items": AppContactFormItemsSchema()]
    }
}
struct AppContactFormSubmissionSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap { ["values": AppContactJSONField(), "metadata": AppContactJSONField().reference(required: false)] }
}
struct AppContactNewsletterSubscriptionSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap { ["email": AppContactEmailField(), "firstName": AppContactNameField().reference(required: false), "lastName": AppContactNameField().reference(required: false)] }
}
