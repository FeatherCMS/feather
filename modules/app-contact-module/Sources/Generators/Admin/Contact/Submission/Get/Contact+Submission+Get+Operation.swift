import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Contact.Submission.Get {
    struct Operation: Contact.Submission.IDOperation {
        var operationId: String? { "contactFormSubmissionGet" }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(
                    description: "Contact form submission not found"
                ),
            ]
        }
    }
}
