import FeatherOpenAPI
import OpenAPIKit30

struct NewsletterCampaignCreateRequestBody: JSONRequestBodyRepresentable {
    var schema = NewsletterCampaignCreateSchema().reference()
}
struct NewsletterCampaignPatchRequestBody: JSONRequestBodyRepresentable {
    var schema = NewsletterCampaignPatchSchema().reference()
}
