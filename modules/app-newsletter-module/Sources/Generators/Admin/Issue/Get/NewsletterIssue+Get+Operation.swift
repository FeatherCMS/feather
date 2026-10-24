import FeatherOpenAPI
import FeatherOpenAPIGenerator

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
