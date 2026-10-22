import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterSubscriberCreateOperation: NewsletterSubscriberOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        NewsletterSubscriberCreateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: NewsletterSubscriberResponse().reference()]
    }
}
