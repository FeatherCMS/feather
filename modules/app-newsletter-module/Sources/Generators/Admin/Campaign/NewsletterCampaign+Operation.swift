import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterCampaign {
    protocol Operation: BearerProtectedOperation {}

    protocol KeyOperation: Operation {}
}

extension NewsletterCampaign.Operation {
    var tags: [any TagRepresentable] { [NewsletterCampaign.Tag()] }
}

extension NewsletterCampaign.KeyOperation {
    var parameters: [any ParameterRepresentable] {
        [NewsletterCampaignKeyParameter().reference()]
    }
}
