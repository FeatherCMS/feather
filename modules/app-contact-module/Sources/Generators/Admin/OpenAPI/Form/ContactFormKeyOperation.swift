import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol ContactFormKeyOperation: ContactFormOperation {}

extension ContactFormKeyOperation {
    var parameters: [any ParameterRepresentable] {
        [ContactFormKeyParameter().reference()]
    }
}
