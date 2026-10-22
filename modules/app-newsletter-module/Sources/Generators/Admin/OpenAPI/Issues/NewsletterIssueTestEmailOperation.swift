import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterIssueTestEmailOperation: NewsletterIssueIDOperation {
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
