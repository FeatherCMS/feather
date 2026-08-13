import FeatherOpenAPI
import OpenAPIKit30

struct NewsletterSubjectField: StringSchemaRepresentable {}
struct NewsletterContentField: StringSchemaRepresentable {}
struct NewsletterIssueStatusField: StringSchemaRepresentable {
    var enumValues: [String]? = [
        "draft", "scheduled", "sending", "sent", "failed",
    ]
}

struct NewsletterIssueSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": NewsletterIdField(),
            "newsletterId": NewsletterIdField(),
            "subject": NewsletterSubjectField(),
            "content": NewsletterContentField(),
            "status": NewsletterIssueStatusField(),
            "scheduledAt": NewsletterTimestampField()
                .reference(required: false),
            "sentAt": NewsletterTimestampField().reference(required: false),
            "createdAt": NewsletterTimestampField(),
            "updatedAt": NewsletterTimestampField(),
        ]
    }
}

struct NewsletterIssueListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { NewsletterIssueSchema().reference() }
}
struct NewsletterIssueCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "subject": NewsletterSubjectField(),
            "content": NewsletterContentField(),
            "scheduledAt": NewsletterTimestampField()
                .reference(required: false),
        ]
    }
}
struct NewsletterIssuePatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "subject": NewsletterSubjectField().reference(required: false),
            "content": NewsletterContentField().reference(required: false),
            "scheduledAt": NewsletterTimestampField()
                .reference(required: false),
        ]
    }
}
struct NewsletterIssueTestEmailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": NewsletterEmailField(),
            "subject": NewsletterSubjectField(),
            "content": NewsletterContentField(),
        ]
    }
}
