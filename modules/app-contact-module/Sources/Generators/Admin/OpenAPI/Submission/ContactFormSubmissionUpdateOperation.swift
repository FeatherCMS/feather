import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct ContactFormSubmissionUpdateOperation: ContactFormSubmissionIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        ContactFormSubmissionPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: ContactFormSubmissionResponse().reference(),
            404: CustomResponse(
                description: "Contact form submission not found"
            ),
        ]
    }
}
