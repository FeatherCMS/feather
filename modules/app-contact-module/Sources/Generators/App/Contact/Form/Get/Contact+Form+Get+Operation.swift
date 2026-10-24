import FeatherOpenAPI

extension Contact.Form.Get {
    struct Operation: Contact.Operation {
        var operationId: String? { "appContactFormGet" }
        var tags: [any TagRepresentable] { [Contact.Form.Tag()] }
        var parameters: [any ParameterRepresentable] {
            [Contact.Form.Parameters.Key().reference()]
        }
        var responseMap: ResponseMap { [200: Response().reference()] }
    }
}
