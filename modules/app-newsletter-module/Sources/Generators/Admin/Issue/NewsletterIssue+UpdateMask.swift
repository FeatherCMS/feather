import FeatherOpenAPI

struct NewsletterIssueUpdateMaskParameter: QueryParameterRepresentable {
    var name: String { "updateMask" }
    var required: Bool { true }
    var description: String? { "Comma-separated list of fields to update." }
    var schema: any OpenAPISchemaRepresentable {
        NewsletterIssueUpdateMaskSchema().reference()
    }
}

struct NewsletterIssueUpdateMaskSchema: StringSchemaRepresentable {
    var openAPIIdentifier: String { "NewsletterIssueUpdateMask" }
    var example: String? { "subject,content,scheduledAt" }
}
