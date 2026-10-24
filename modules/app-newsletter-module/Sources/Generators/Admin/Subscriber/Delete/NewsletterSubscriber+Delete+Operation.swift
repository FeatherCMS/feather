import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension NewsletterSubscriber.Delete {
    struct Operation: NewsletterSubscriber.Operation, DeleteOperation {
        var operationId: String? { "newsletterSubscriberRemove" }
    }
}
