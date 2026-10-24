import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension NewsletterIssue.Get {
    struct Operation: NewsletterIssue.IDOperation {
        var operationId: String? { "newsletterIssueGet" }

        var responseMap: ResponseMap {
            [
                200: NewsletterIssueResponse().reference(),
                404: CustomResponse(description: "Newsletter issue not found"),
            ]
        }
    }
}
