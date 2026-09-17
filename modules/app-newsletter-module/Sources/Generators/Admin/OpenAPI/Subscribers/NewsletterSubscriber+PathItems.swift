import FeatherOpenAPI

struct NewsletterSubscriberPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsletterSubscriberListOperation() }
    var post: OperationRepresentable? { NewsletterSubscriberCreateOperation() }
    var delete: OperationRepresentable? {
        NewsletterSubscriberRemoveOperation()
    }
}
struct NewsletterSubscriberIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsletterSubscriberGetOperation() }
    var patch: OperationRepresentable? { NewsletterSubscriberUpdateOperation() }
}
