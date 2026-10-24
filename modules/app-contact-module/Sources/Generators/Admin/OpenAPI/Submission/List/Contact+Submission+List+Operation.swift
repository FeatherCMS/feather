import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Contact.Submission.List {
    struct Operation: Contact.Submission.KeyOperation {
        var operationId: String? { "contactFormSubmissionList" }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
