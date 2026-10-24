import FeatherOpenAPI

extension Contact.Form.Email {
    struct AdditionalHeaders: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "ContactAdditionalHeadersSchema" }
        var items: (any SchemaRepresentable)? { Contact.Schemas.Content() }
    }
}
