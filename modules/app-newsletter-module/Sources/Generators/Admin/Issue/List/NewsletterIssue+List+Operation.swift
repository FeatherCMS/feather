import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterIssue.List {
    struct Operation: NewsletterIssue.Operation {
        var operationId: String? { "newsletterIssueList" }

        var responseMap: ResponseMap {
            [200: NewsletterIssueListResponse().reference()]
        }
    }
}
