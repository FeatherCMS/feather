import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol ContactFormSubmissionOperation: ContactFormOperation {}
extension ContactFormSubmissionOperation {
    var parameters: [any ParameterRepresentable] {
        [ContactFormKeyParameter().reference()]
    }
}
protocol ContactFormSubmissionIDOperation: ContactFormSubmissionOperation {}
extension ContactFormSubmissionIDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            ContactFormKeyParameter().reference(),
            ContactFormSubmissionIdParameter().reference(),
        ]
    }
}

struct ContactFormSubmissionListOperation: ContactFormSubmissionOperation {
    var responseMap: ResponseMap {
        [200: ContactFormSubmissionListResponse().reference()]
    }
}
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
struct ContactFormSubmissionRemoveOperation: ContactFormSubmissionOperation,
    DeleteOperation
{}
