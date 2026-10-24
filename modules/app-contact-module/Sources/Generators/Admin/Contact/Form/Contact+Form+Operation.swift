import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Form {
    protocol Operation: Contact.Operation {}
    protocol KeyOperation: Operation {}
}

extension Contact.Form.KeyOperation {
    var parameters: [any ParameterRepresentable] {
        [Contact.Form.Parameters.Key().reference()]
    }
}
