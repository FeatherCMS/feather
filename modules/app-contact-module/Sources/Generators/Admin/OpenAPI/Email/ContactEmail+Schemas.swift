import FeatherOpenAPI
import OpenAPIKit30

struct ContactAdditionalHeadersSchema: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? { ContactContentField() }
}

struct SubmissionMailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": ContactIdField(),
            "mailFrom": ContactEmailField(),
            "mailTo": ContactEmailField(),
            "subject": ContactSubjectField(),
            "additionalHeaders": ContactAdditionalHeadersSchema(),
            "messageBody": ContactContentField(),
            "createdAt": ContactTimestampField(),
            "updatedAt": ContactTimestampField(),
        ]
    }
}
struct SubmissionMailsSchema: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? { SubmissionMailSchema().reference() }
}
struct SubmissionMailInputSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "mailFrom": ContactEmailField(),
            "mailTo": ContactEmailField(),
            "subject": ContactSubjectField(),
            "additionalHeaders": ContactAdditionalHeadersSchema()
                .reference(required: false),
            "messageBody": ContactContentField(),
        ]
    }
}
struct SubmissionMailInputsSchema: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? {
        SubmissionMailInputSchema().reference()
    }
}
