import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterIssueGetOperation: NewsletterIssueIDOperation {
    var responseMap: ResponseMap {
        [
            200: NewsletterIssueResponse().reference(),
            404: CustomResponse(description: "Newsletter issue not found"),
        ]
    }
}
