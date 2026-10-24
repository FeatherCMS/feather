import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterSubscriber.Post {
    struct Operation: NewsletterSubscriber.Operation {
        var operationId: String? { "newsletterSubscriberCreate" }

        var requestBody: (any RequestBodyRepresentable)? {
            NewsletterSubscriberCreateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: NewsletterSubscriberResponse().reference()]
        }
    }
}
