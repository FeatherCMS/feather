import FeatherOpenAPI

extension Contact.Submission.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "ContactFormSubmissionUpdateMask" }
        var example: String? { "status" }
    }
}
