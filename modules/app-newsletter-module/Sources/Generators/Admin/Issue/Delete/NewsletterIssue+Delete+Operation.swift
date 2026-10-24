import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension NewsletterIssue.Delete {
    struct Operation: NewsletterIssue.Operation, DeleteOperation {
        var operationId: String? { "newsletterIssueRemove" }
    }
}
