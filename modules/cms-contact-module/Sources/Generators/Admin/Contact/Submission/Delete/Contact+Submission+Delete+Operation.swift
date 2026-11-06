import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Submission.Delete {
    struct Operation: Contact.Submission.KeyOperation, DeleteOperation {
        var operationId: String? { "contactFormSubmissionRemove" }
    }
}
