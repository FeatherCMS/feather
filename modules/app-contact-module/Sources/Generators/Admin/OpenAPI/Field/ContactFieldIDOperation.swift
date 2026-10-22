import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol ContactFieldIDOperation: ContactFieldOperation {}

extension ContactFieldIDOperation {
    var parameters: [any ParameterRepresentable] {
        [FormFieldIdParameter().reference()]
    }
}
