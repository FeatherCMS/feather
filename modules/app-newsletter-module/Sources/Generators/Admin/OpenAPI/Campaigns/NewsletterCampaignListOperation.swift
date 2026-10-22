import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterCampaignListOperation: NewsletterCampaignOperation {
    var responseMap: ResponseMap {
        [200: NewsletterCampaignListResponse().reference()]
    }
}
