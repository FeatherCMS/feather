import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsletterIssueIDOperation: NewsletterIssueOperation {}

extension NewsletterIssueIDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            NewsletterCampaignKeyParameter().reference(),
            NewsletterIssueIdParameter().reference(),
        ]
    }
}
