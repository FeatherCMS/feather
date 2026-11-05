import FeatherOpenAPI
import FeatherOpenAPIGenerator

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
