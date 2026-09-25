import FeatherOpenAPI
import OpenAPIKit30

struct ContactIdField: StringSchemaRepresentable {}
struct ContactFormKeyField: StringSchemaRepresentable {}
struct ContactNameField: StringSchemaRepresentable {}
struct ContactEmailField: StringSchemaRepresentable {}
struct ContactSubjectField: StringSchemaRepresentable {}
struct ContactContentField: StringSchemaRepresentable {}
struct ContactTimestampField: DoubleSchemaRepresentable {}

struct ContactJSONField: SchemaRepresentable {
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

struct ContactFormSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "key": ContactFormKeyField(),
            "name": ContactNameField(),
            "successMessage": ContactContentField(),
            "failureMessage": ContactContentField(),
            "redirectUrl": ContactContentField().reference(required: false),
            "items": FormFieldsSchema().reference(required: false),
            "mails": SubmissionMailsSchema().reference(required: false),
            "createdAt": ContactTimestampField(),
            "updatedAt": ContactTimestampField(),
        ]
    }
}

struct ContactFormListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { ContactFormSchema().reference() }
}

struct ContactFormCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "key": ContactFormKeyField(),
            "name": ContactNameField(),
            "successMessage": ContactContentField().reference(required: false),
            "failureMessage": ContactContentField().reference(required: false),
            "redirectUrl": ContactContentField().reference(required: false),
            "fieldIds": ContactFieldIDsSchema().reference(required: false),
            "mails": SubmissionMailInputsSchema().reference(required: false),
        ]
    }
}
