import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterSubscriber {
    protocol Operation: NewsletterCampaign.Operation {}

    protocol IDOperation: Operation {}
}

extension NewsletterSubscriber.Operation {
    var parameters: [any ParameterRepresentable] {
        [NewsletterCampaignKeyParameter().reference()]
    }
}

extension NewsletterSubscriber.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            NewsletterCampaignKeyParameter().reference(),
            NewsletterSubscriberEmailParameter().reference(),
        ]
    }
}
