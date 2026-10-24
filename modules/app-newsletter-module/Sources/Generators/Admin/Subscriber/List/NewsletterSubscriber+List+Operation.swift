import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension NewsletterSubscriber.List {
    struct Operation: NewsletterSubscriber.Operation {
        var operationId: String? { "newsletterSubscriberList" }

        var responseMap: ResponseMap {
            [200: NewsletterSubscriberListResponse().reference()]
        }
    }
}
