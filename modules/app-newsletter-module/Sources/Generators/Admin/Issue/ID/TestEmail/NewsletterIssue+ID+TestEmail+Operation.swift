import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterIssue.ID.TestEmail {
    struct Operation: NewsletterIssue.IDOperation {
        var operationId: String? { "newsletterIssueTestEmail" }

        var requestBody: (any RequestBodyRepresentable)? {
            NewsletterIssueTestEmailRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                204: NoContentResponse(description: "Test email queued"),
                404: CustomResponse(description: "Newsletter issue not found"),
            ]
        }
    }
}
