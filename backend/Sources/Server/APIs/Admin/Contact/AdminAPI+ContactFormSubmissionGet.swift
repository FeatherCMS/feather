import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFormSubmissionGet(
        _ input: Operations.ContactFormSubmissionGet.Input
    ) async throws -> Operations.ContactFormSubmissionGet.Output {
        try await modules.contact.authorize(
            permission: ContactPermissions.Submissions.read
        )
        let result = try await modules.contact.makeGetContactFormSubmission()
            .execute(.init(id: input.path.contactFormSubmissionId))
        return .ok(.init(body: .json(map(result))))
    }
}
