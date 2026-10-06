import FeatherOpenAPI

struct NewsletterSubscriberPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? {
        NewsletterSubscriberListOperation()
    }
    var post: (any OperationRepresentable)? {
        NewsletterSubscriberCreateOperation()
    }
    var delete: (any OperationRepresentable)? {
        NewsletterSubscriberRemoveOperation()
    }
}
struct NewsletterSubscriberIDPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? {
        NewsletterSubscriberGetOperation()
    }
    var patch: (any OperationRepresentable)? {
        NewsletterSubscriberUpdateOperation()
    }
}
