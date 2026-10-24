import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterIssueUpdateOperation: NewsletterIssueIDOperation {
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
            400: DefaultHTTPErrorContentResponse(description: "Bad Request"),
            404: CustomResponse(description: "Newsletter issue not found"),
        ]
    }
}
