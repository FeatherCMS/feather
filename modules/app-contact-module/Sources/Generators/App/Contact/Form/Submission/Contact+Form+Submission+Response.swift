import FeatherOpenAPI

extension Contact.Form.Submission {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AppContactFormSubmissionResponse" }
        var description: String = "Contact form submission response"
        var schema = ResponseSchema().reference()
    }
}
