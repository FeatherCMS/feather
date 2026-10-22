import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterCampaignTestEmailOperation: NewsletterIssueOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        NewsletterIssueTestEmailRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [204: NoContentResponse(description: "Test email queued")]
    }
}
