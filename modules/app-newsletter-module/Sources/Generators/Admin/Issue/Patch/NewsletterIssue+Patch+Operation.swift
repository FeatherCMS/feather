import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterIssue.Patch {
    struct Operation: NewsletterIssue.IDOperation {
        var operationId: String? { "newsletterIssueUpdate" }

        var parameters: [any ParameterRepresentable] {
            [
                NewsletterCampaignKeyParameter().reference(),
                NewsletterIssueIdParameter().reference(),
                NewsletterIssueUpdateMaskParameter().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            NewsletterIssuePatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: NewsletterIssueResponse().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "Newsletter issue not found"),
            ]
        }
    }
}
