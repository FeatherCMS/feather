import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Subscriber.Delete {
    struct Operation: Subscriber.Operation, DeleteOperation {
        var operationId: String? { "newsletterSubscriberRemove" }
    }
}
