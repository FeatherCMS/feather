import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol ContactFormSubmissionOperation: ContactFormOperation {}

extension ContactFormSubmissionOperation {
    var parameters: [any ParameterRepresentable] {
        [ContactFormKeyParameter().reference()]
    }
}
