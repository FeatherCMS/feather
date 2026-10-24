import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterIssue.Delete {
    struct Operation: NewsletterIssue.Operation, DeleteOperation {
        var operationId: String? { "newsletterIssueRemove" }
    }
}
