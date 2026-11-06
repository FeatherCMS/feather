import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Subscriber.List {
    struct Operation: Subscriber.Operation {
        var operationId: String? { "newsletterSubscriberList" }

        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
