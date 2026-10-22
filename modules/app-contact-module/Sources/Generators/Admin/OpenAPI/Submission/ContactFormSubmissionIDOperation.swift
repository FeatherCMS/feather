import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol ContactFormSubmissionIDOperation: ContactFormSubmissionOperation {}

extension ContactFormSubmissionIDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            ContactFormKeyParameter().reference(),
            ContactFormSubmissionIdParameter().reference(),
        ]
    }
}
