import FeatherOpenAPI

extension Issue.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterIssueUpdateMask" }
        var example: String? { "subject,content,scheduledAt" }
    }
}
