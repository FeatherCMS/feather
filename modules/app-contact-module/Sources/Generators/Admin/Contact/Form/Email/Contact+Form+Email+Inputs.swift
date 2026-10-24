import FeatherOpenAPI

extension Contact.Form.Email {
    struct Inputs: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "SubmissionMailInputsSchema" }
        var items: (any SchemaRepresentable)? {
            InputSchema().reference()
        }
    }
}
