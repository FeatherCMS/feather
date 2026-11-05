import FeatherOpenAPI

extension Issue.Post {
    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String { "NewsletterIssueCreateRequestBody" }
        var schema = Schema().reference()
    }
}
