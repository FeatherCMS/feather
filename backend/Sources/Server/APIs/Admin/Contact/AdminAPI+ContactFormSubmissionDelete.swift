import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFormSubmissionDelete(
        _ input: Operations.ContactFormSubmissionDelete.Input
    ) async throws -> Operations.ContactFormSubmissionDelete.Output {
        try await modules.contact.authorize(permission: ContactPermissions.Submissions.delete)
        _ = try await modules.contact.makeDeleteContactFormSubmission().execute(
            .init(id: input.path.contactFormSubmissionId)
        )
        return .noContent
    }
}
