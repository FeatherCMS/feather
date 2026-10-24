import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

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
