import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Issue.TestEmail {
    struct Operation: Issue.Operation {
        var operationId: String? { "newsletterCampaignTestEmail" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [204: NoContentResponse(description: "Test email queued")]
        }
    }
}
