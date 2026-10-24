import FeatherOpenAPI

extension Contact.Submission.Schemas {
    struct Status: StringSchemaRepresentable {
        var enumValues: [String]? = ["received", "processed", "spam", "failed"]
    }
}
