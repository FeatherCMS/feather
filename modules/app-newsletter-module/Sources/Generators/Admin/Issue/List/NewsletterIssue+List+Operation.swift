import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension NewsletterIssue.List {
    struct Operation: NewsletterIssue.Operation {
        var operationId: String? { "newsletterIssueList" }

        var responseMap: ResponseMap {
            [200: NewsletterIssueListResponse().reference()]
        }
    }
}
