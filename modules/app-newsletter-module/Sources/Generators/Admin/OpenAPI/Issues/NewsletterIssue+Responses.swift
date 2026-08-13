import FeatherOpenAPI

struct NewsletterIssueResponse: JSONResponseRepresentable {
    var description: String = "Newsletter issue response"
    var schema = NewsletterIssueSchema().reference()
}
struct NewsletterIssueListResponse: JSONResponseRepresentable {
    var description: String = "Newsletter issue list response"
    var schema = NewsletterIssueListSchema().reference()
}
