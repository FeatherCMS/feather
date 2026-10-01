import FeatherOpenAPI

struct NewsletterIssueDeliveryListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { NewsletterIssueDeliveryListOperation() }
}
