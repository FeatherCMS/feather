import FeatherOpenAPI

extension Issue.Schemas {
    struct Status: StringSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterIssueStatusField" }
        var enumValues: [String]? = ["draft", "scheduled", "sending", "sent", "failed"]
    }
}
