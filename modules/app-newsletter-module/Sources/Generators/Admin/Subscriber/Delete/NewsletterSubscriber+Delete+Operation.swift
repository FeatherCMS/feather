import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterSubscriber.Delete {
    struct Operation: NewsletterSubscriber.Operation, DeleteOperation {
        var operationId: String? { "newsletterSubscriberRemove" }
    }
}
