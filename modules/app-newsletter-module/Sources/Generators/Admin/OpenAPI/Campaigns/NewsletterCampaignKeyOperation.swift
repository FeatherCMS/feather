import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsletterCampaignKeyOperation: NewsletterCampaignOperation {}

extension NewsletterCampaignKeyOperation {
    var parameters: [any ParameterRepresentable] {
        [NewsletterCampaignKeyParameter().reference()]
    }
}
