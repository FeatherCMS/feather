import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterCampaignGetOperation: NewsletterCampaignKeyOperation {
    var responseMap: ResponseMap {
        [
            200: NewsletterCampaignResponse().reference(),
            404: CustomResponse(description: "Newsletter not found"),
        ]
    }
}
