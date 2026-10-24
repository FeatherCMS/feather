import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Contact.Submission.Patch {
    struct Operation: Contact.Submission.IDOperation {
        var operationId: String? { "contactFormSubmissionUpdate" }
        var parameters: [any ParameterRepresentable] {
            [
                Contact.Form.Parameters.Key().reference(),
                Contact.Submission.Parameters.ID().reference(),
                Contact.Submission.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Contact.Submission.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(
                    description: "Contact form submission not found"
                ),
            ]
        }
    }
}
