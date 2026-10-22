import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterCampaignCreateOperation: NewsletterCampaignOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        NewsletterCampaignCreateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: NewsletterCampaignResponse().reference()]
    }
}
