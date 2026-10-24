import FeatherOpenAPI

extension Contact.Form.Submission {
    struct Operation: Contact.Operation {
        var operationId: String? { "appContactFormSubmission" }
        var tags: [any TagRepresentable] { [Contact.Form.Tag()] }
        var parameters: [any ParameterRepresentable] {
            [Contact.Form.Parameters.Key().reference()]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap { [201: Response().reference()] }
    }
}
