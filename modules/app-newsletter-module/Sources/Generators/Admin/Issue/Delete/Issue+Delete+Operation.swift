import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Issue.Delete {
    struct Operation: Issue.Operation, DeleteOperation {
        var operationId: String? { "newsletterIssueRemove" }
    }
}
