import FeatherOpenAPI

extension Contact {
    struct Tag: TagRepresentable {
        var name: String = "ContactForms"
        var description: String? =
            "Manage contact forms, fields, and submissions."
    }
}
