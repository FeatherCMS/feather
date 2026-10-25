import FeatherOpenAPI

extension Issue.TestEmail {
    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String { "NewsletterIssueTestEmailRequestBody" }
        var schema = Schema().reference()
    }
}
