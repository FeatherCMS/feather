import FeatherOpenAPI

extension Issue.Schemas {
    struct Subject: StringSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterSubjectField" }
    }
}
