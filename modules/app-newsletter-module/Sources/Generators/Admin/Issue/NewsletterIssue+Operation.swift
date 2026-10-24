import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension NewsletterIssue {
    protocol Operation: NewsletterCampaign.Operation {}

    protocol IDOperation: Operation {}
}

extension NewsletterIssue.Operation {
    var parameters: [any ParameterRepresentable] {
        [NewsletterCampaignKeyParameter().reference()]
    }
}

extension NewsletterIssue.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            NewsletterCampaignKeyParameter().reference(),
            NewsletterIssueIdParameter().reference(),
        ]
    }
}
