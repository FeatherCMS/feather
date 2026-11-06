import FeatherOpenAPI

extension Contact.Submission {
    protocol Operation: Contact.Operation {}
    protocol KeyOperation: Operation {}
    protocol IDOperation: KeyOperation {}
}

extension Contact.Submission.KeyOperation {
    var parameters: [any ParameterRepresentable] {
        [Contact.Form.Parameters.Key().reference()]
    }
}

extension Contact.Submission.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            Contact.Form.Parameters.Key().reference(),
            Contact.Submission.Parameters.ID().reference(),
        ]
    }
}
