import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterCampaign.List {
    struct Operation: NewsletterCampaign.Operation {
        var operationId: String? { "newsletterCampaignList" }

        var responseMap: ResponseMap {
            [200: NewsletterCampaignListResponse().reference()]
        }
    }
}
