import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterSubscriberListOperation: NewsletterSubscriberOperation {
    var responseMap: ResponseMap {
        [200: NewsletterSubscriberListResponse().reference()]
    }
}
