import FeatherOpenAPI
import OpenAPIKit30

struct NewsletterIssueCreateRequestBody: JSONRequestBodyRepresentable {
    var schema = NewsletterIssueCreateSchema().reference()
}
struct NewsletterIssuePatchRequestBody: JSONRequestBodyRepresentable {
    var schema = NewsletterIssuePatchSchema().reference()
}
struct NewsletterIssueTestEmailRequestBody: JSONRequestBodyRepresentable {
    var schema = NewsletterIssueTestEmailSchema().reference()
}
