import FeatherOpenAPI

extension Contact.Schemas {
    struct Subject: StringSchemaRepresentable {
        var openAPIIdentifier: String { "ContactSubjectField" }
    }
}
