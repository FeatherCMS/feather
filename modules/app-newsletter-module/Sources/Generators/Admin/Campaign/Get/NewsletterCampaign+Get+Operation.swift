import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterCampaign.Get {
    struct Operation: NewsletterCampaign.KeyOperation {
        var operationId: String? { "newsletterCampaignGet" }

        var responseMap: ResponseMap {
            [
                200: NewsletterCampaignResponse().reference(),
                404: CustomResponse(description: "Newsletter not found"),
            ]
        }
    }
}
