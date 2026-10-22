import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterSubscriberGetOperation: NewsletterSubscriberIDOperation {
    var responseMap: ResponseMap {
        [
            200: NewsletterSubscriberResponse().reference(),
            404: CustomResponse(description: "Newsletter subscriber not found"),
        ]
    }
}
