import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsletterSubscriberIDOperation: NewsletterSubscriberOperation {}

extension NewsletterSubscriberIDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            NewsletterCampaignKeyParameter().reference(),
            NewsletterSubscriberEmailParameter().reference(),
        ]
    }
}
