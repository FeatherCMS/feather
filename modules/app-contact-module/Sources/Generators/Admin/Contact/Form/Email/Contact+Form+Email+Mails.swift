import FeatherOpenAPI

extension Contact.Form.Email {
    struct Mails: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "SubmissionMailsSchema" }
        var items: (any SchemaRepresentable)? { Schema().reference() }
    }
}
