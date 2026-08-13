import FeatherOpenAPI
import OpenAPIKit30

struct SubmissionMailSchema: ObjectSchemaRepresentable {
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
struct SubmissionMailsSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { SubmissionMailSchema().reference() }
}
struct SubmissionMailInputSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "mailFrom": ContactEmailField(),
            "mailTo": ContactEmailField(),
            "subject": ContactSubjectField(),
            "additionalHeaders": ContactContentField()
                .reference(required: false),
            "messageBody": ContactContentField(),
        ]
    }
}
struct SubmissionMailInputsSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { SubmissionMailInputSchema().reference() }
}
