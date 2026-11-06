import FeatherOpenAPI

extension Issue.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "NewsletterIssueListResponse" }
        var description: String = "Newsletter issue list response"
        var schema = Schema().reference()
    }
}
