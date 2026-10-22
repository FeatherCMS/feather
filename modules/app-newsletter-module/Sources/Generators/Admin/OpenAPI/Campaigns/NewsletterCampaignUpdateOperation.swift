import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterCampaignUpdateOperation: NewsletterCampaignKeyOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        NewsletterCampaignPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: NewsletterCampaignResponse().reference(),
            404: CustomResponse(description: "Newsletter not found"),
        ]
    }
}
