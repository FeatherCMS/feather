import FeatherOpenAPI

struct NewsletterIssuePathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsletterIssueListOperation() }
    var post: OperationRepresentable? { NewsletterIssueCreateOperation() }
}
struct NewsletterCampaignTestEmailPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { NewsletterCampaignTestEmailOperation() }
}
struct NewsletterIssueIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsletterIssueGetOperation() }
    var patch: OperationRepresentable? { NewsletterIssueUpdateOperation() }
    var delete: OperationRepresentable? { NewsletterIssueDeleteOperation() }
}
struct NewsletterIssueTestEmailPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { NewsletterIssueTestEmailOperation() }
}
