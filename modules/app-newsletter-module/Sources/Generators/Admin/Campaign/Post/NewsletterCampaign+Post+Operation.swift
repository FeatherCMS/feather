import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension NewsletterCampaign.Post {
    struct Operation: NewsletterCampaign.Operation {
        var operationId: String? { "newsletterCampaignCreate" }

        var requestBody: (any RequestBodyRepresentable)? {
            NewsletterCampaignCreateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: NewsletterCampaignResponse().reference()]
        }
    }
}
