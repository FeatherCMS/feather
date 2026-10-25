import FeatherOpenAPI

extension Issue.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "NewsletterIssueResponse" }
        var description: String = "Newsletter issue response"
        var schema = Schema().reference()
    }
}
