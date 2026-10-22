import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct ContactFormSubmissionGetOperation: ContactFormSubmissionIDOperation {
    var responseMap: ResponseMap {
        [
            200: ContactFormSubmissionResponse().reference(),
            404: CustomResponse(
                description: "Contact form submission not found"
            ),
        ]
    }
}
