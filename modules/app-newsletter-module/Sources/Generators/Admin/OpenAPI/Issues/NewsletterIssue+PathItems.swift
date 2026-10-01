import FeatherOpenAPI

struct NewsletterIssuePathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { NewsletterIssueListOperation() }
    var post: (any OperationRepresentable)? { NewsletterIssueCreateOperation() }
    var delete: (any OperationRepresentable)? { NewsletterIssueRemoveOperation() }
}
struct NewsletterCampaignTestEmailPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { NewsletterCampaignTestEmailOperation() }
}
struct NewsletterIssueIDPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { NewsletterIssueGetOperation() }
    var patch: (any OperationRepresentable)? { NewsletterIssueUpdateOperation() }
}
struct NewsletterIssueTestEmailPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { NewsletterIssueTestEmailOperation() }
}
