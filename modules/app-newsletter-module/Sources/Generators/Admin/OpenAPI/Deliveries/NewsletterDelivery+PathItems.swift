import FeatherOpenAPI

struct NewsletterIssueDeliveryListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsletterIssueDeliveryListOperation() }
}
