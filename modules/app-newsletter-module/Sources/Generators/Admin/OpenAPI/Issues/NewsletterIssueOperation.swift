import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsletterIssueOperation: NewsletterCampaignOperation {}

extension NewsletterIssueOperation {
    var parameters: [any ParameterRepresentable] {
        [NewsletterCampaignKeyParameter().reference()]
    }
}
