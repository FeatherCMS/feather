import FeatherOpenAPI

struct NewsletterSubscriberPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsletterSubscriberListOperation() }
    var post: OperationRepresentable? { NewsletterSubscriberCreateOperation() }
}
struct NewsletterSubscriberIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsletterSubscriberGetOperation() }
    var patch: OperationRepresentable? { NewsletterSubscriberUpdateOperation() }
    var delete: OperationRepresentable? {
        NewsletterSubscriberDeleteOperation()
    }
}
