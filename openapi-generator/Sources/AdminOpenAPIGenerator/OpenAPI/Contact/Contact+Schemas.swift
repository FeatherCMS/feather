import FeatherOpenAPI
import OpenAPIKit30

struct ContactIdField: StringSchemaRepresentable {}
struct ContactNameField: StringSchemaRepresentable {}
struct ContactEmailField: StringSchemaRepresentable {}
struct ContactLabelField: StringSchemaRepresentable {}
struct ContactKeyField: StringSchemaRepresentable {}
struct ContactTypeField: StringSchemaRepresentable {
    var enumValues: [String]? = ["text", "textarea", "select", "radio", "toggle"]
}
struct ContactAllowedValueField: StringSchemaRepresentable {}
struct ContactFormItemPositionField: IntSchemaRepresentable {}
struct ContactRequiredField: BoolSchemaRepresentable {}
struct ContactStatusField: StringSchemaRepresentable {
    var enumValues: [String]? = ["received", "processed", "spam", "failed"]
}
struct ContactNewsletterSubscriberStatusField: StringSchemaRepresentable {
    var enumValues: [String]? = ["subscribed", "unsubscribed"]
}
struct ContactSubjectField: StringSchemaRepresentable {}
struct ContactContentField: StringSchemaRepresentable {}
struct ContactNewsletterIssueStatusField: StringSchemaRepresentable {
    var enumValues: [String]? = ["draft", "scheduled", "sending", "sent", "failed"]
}
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

struct ContactAllowedValuesSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { ContactAllowedValueField() }
}
struct ContactFieldIDsSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { ContactIdField() }
}

struct ContactFormItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": ContactIdField(),
            "formId": ContactIdField(),
            "key": ContactKeyField(),
            "type": ContactTypeField(),
            "label": ContactLabelField(),
            "allowedValues": ContactAllowedValuesSchema().reference(required: false),
            "isRequired": ContactRequiredField(),
            "position": ContactFormItemPositionField(),
            "createdAt": ContactTimestampField(),
            "updatedAt": ContactTimestampField(),
        ]
    }
}
struct ContactFormItemsSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { ContactFormItemSchema().reference() }
}

struct ContactFormMailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": ContactIdField(),
            "formId": ContactIdField(),
            "mailFrom": ContactEmailField(),
            "mailTo": ContactEmailField(),
            "subject": ContactSubjectField(),
            "additionalHeaders": ContactContentField(),
            "messageBody": ContactContentField(),
            "createdAt": ContactTimestampField(),
            "updatedAt": ContactTimestampField(),
        ]
    }
}
struct ContactFormMailsSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { ContactFormMailSchema().reference() }
}

struct ContactFormSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": ContactIdField(),
            "name": ContactNameField(),
            "successMessage": ContactContentField(),
            "failureMessage": ContactContentField(),
            "redirectUrl": ContactContentField().reference(required: false),
            "items": ContactFormItemsSchema().reference(required: false),
            "mails": ContactFormMailsSchema().reference(required: false),
            "createdAt": ContactTimestampField(),
            "updatedAt": ContactTimestampField(),
        ]
    }
}

struct ContactFormSubmissionSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": ContactIdField(),
            "formId": ContactIdField(),
            "values": ContactJSONField(),
            "itemsSnapshot": ContactJSONField(),
            "metadata": ContactJSONField(),
            "status": ContactStatusField(),
            "createdAt": ContactTimestampField(),
            "updatedAt": ContactTimestampField(),
        ]
    }
}

struct ContactNewsletterSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": ContactIdField(),
            "name": ContactNameField(),
            "createdAt": ContactTimestampField(),
            "updatedAt": ContactTimestampField(),
        ]
    }
}

struct ContactNewsletterIssueSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": ContactIdField(),
            "newsletterId": ContactIdField(),
            "subject": ContactSubjectField(),
            "content": ContactContentField(),
            "status": ContactNewsletterIssueStatusField(),
            "scheduledAt": ContactTimestampField().reference(required: false),
            "sentAt": ContactTimestampField().reference(required: false),
            "createdAt": ContactTimestampField(),
            "updatedAt": ContactTimestampField(),
        ]
    }
}

struct ContactNewsletterSubscriberSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": ContactIdField(),
            "newsletterId": ContactIdField(),
            "email": ContactEmailField(),
            "status": ContactNewsletterSubscriberStatusField(),
            "subscriptionDate": ContactTimestampField(),
            "unsubscriptionDate": ContactTimestampField().reference(required: false),
            "firstName": ContactNameField().reference(required: false),
            "lastName": ContactNameField().reference(required: false),
            "createdAt": ContactTimestampField(),
            "updatedAt": ContactTimestampField(),
        ]
    }
}

struct ContactFormListSchema: ArraySchemaRepresentable { var items: SchemaRepresentable? { ContactFormSchema().reference() } }
struct ContactFormItemListSchema: ArraySchemaRepresentable { var items: SchemaRepresentable? { ContactFormItemSchema().reference() } }
struct ContactFormSubmissionListSchema: ArraySchemaRepresentable { var items: SchemaRepresentable? { ContactFormSubmissionSchema().reference() } }
struct ContactNewsletterListSchema: ArraySchemaRepresentable { var items: SchemaRepresentable? { ContactNewsletterSchema().reference() } }
struct ContactNewsletterIssueListSchema: ArraySchemaRepresentable { var items: SchemaRepresentable? { ContactNewsletterIssueSchema().reference() } }
struct ContactNewsletterSubscriberListSchema: ArraySchemaRepresentable { var items: SchemaRepresentable? { ContactNewsletterSubscriberSchema().reference() } }

struct ContactFormCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap { ["name": ContactNameField(), "successMessage": ContactContentField().reference(required: false), "failureMessage": ContactContentField().reference(required: false), "redirectUrl": ContactContentField().reference(required: false), "fieldIds": ContactFieldIDsSchema().reference(required: false), "mails": ContactFormMailInputsSchema().reference(required: false)] }
}
struct ContactFormMailInputSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "mailFrom": ContactEmailField(),
            "mailTo": ContactEmailField(),
            "subject": ContactSubjectField(),
            "additionalHeaders": ContactContentField().reference(required: false),
            "messageBody": ContactContentField(),
        ]
    }
}
struct ContactFormMailInputsSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { ContactFormMailInputSchema().reference() }
}
struct ContactFormItemCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        ["key": ContactKeyField(), "type": ContactTypeField(), "label": ContactLabelField(), "allowedValues": ContactAllowedValuesSchema().reference(required: false), "isRequired": ContactRequiredField().reference(required: false), "position": ContactFormItemPositionField().reference(required: false)]
    }
}
struct ContactFormItemPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        ["key": ContactKeyField().reference(required: false), "type": ContactTypeField().reference(required: false), "label": ContactLabelField().reference(required: false), "allowedValues": ContactAllowedValuesSchema().reference(required: false), "isRequired": ContactRequiredField().reference(required: false), "position": ContactFormItemPositionField().reference(required: false)]
    }
}
struct ContactFormSubmissionPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap { ["status": ContactStatusField()] }
}
struct ContactNewsletterCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap { ["name": ContactNameField()] }
}
struct ContactNewsletterPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap { ["name": ContactNameField().reference(required: false)] }
}
struct ContactNewsletterIssueCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap { ["subject": ContactSubjectField(), "content": ContactContentField(), "scheduledAt": ContactTimestampField().reference(required: false)] }
}
struct ContactNewsletterIssuePatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap { ["subject": ContactSubjectField().reference(required: false), "content": ContactContentField().reference(required: false), "scheduledAt": ContactTimestampField().reference(required: false)] }
}
struct ContactNewsletterSubscriberCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap { ["email": ContactEmailField(), "firstName": ContactNameField().reference(required: false), "lastName": ContactNameField().reference(required: false), "status": ContactNewsletterSubscriberStatusField().reference(required: false)] }
}
struct ContactNewsletterSubscriberPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap { ["firstName": ContactNameField().reference(required: false), "lastName": ContactNameField().reference(required: false), "status": ContactNewsletterSubscriberStatusField()] }
}
