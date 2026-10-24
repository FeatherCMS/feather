import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterIssue.Post {
    struct Operation: NewsletterIssue.Operation {
        var operationId: String? { "newsletterIssueCreate" }

        var requestBody: (any RequestBodyRepresentable)? {
            NewsletterIssueCreateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: NewsletterIssueResponse().reference()]
        }
    }
}
