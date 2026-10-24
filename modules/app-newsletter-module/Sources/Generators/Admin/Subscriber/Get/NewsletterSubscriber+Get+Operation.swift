import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterSubscriber.Get {
    struct Operation: NewsletterSubscriber.IDOperation {
        var operationId: String? { "newsletterSubscriberGet" }

        var responseMap: ResponseMap {
            [
                200: NewsletterSubscriberResponse().reference(),
                404: CustomResponse(
                    description: "Newsletter subscriber not found"
                ),
            ]
        }
    }
}
