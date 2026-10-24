import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension NewsletterIssue.TestEmail {
    struct Operation: NewsletterIssue.Operation {
        var operationId: String? { "newsletterCampaignTestEmail" }

        var requestBody: (any RequestBodyRepresentable)? {
            NewsletterIssueTestEmailRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [204: NoContentResponse(description: "Test email queued")]
        }
    }
}
