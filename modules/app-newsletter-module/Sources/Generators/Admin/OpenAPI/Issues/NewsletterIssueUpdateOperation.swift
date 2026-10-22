import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterIssueUpdateOperation: NewsletterIssueIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        NewsletterIssuePatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: NewsletterIssueResponse().reference(),
            404: CustomResponse(description: "Newsletter issue not found"),
        ]
    }
}
