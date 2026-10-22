import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsletterSubscriberOperation: NewsletterCampaignOperation {}

extension NewsletterSubscriberOperation {
    var parameters: [any ParameterRepresentable] {
        [NewsletterCampaignKeyParameter().reference()]
    }
}
