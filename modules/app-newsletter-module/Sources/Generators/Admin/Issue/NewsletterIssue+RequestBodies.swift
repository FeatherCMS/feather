import FeatherOpenAPI

struct NewsletterIssueCreateRequestBody: JSONRequestBodyRepresentable {
    var schema = NewsletterIssueCreateSchema().reference()
}
struct NewsletterIssuePatchRequestBody: JSONRequestBodyRepresentable {
    var schema = NewsletterIssuePatchSchema().reference()
}
struct NewsletterIssueTestEmailRequestBody: JSONRequestBodyRepresentable {
    var schema = NewsletterIssueTestEmailSchema().reference()
}
