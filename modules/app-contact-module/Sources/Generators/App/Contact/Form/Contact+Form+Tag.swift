import FeatherOpenAPI

extension Contact.Form {
    struct Tag: TagRepresentable {
        var name: String { "ContactForms" }
        var description: String? { "Public contact form endpoints." }
    }
}
