import AdminOpenAPI
import ContactApplication
import ContactDomain
import Hummingbird

extension AdminAPI {
    func contactFormSubmissionUpdate(
        _ input: Operations.ContactFormSubmissionUpdate.Input
    ) async throws -> Operations.ContactFormSubmissionUpdate.Output {
        try await modules.contact.authorize(
            permission: ContactPermissions.Submissions.update
        )
        let body: Components.Schemas.ContactFormSubmissionPatchSchema
        switch input.body {
        case let .json(value): body = value
        }
        guard let status = ContactFormSubmission.Status(rawValue: body.status)
        else { throw HTTPError(.badRequest) }
        let result = try await modules.contact.makeUpdateContactFormSubmission()
            .execute(
                .init(id: input.path.contactFormSubmissionId, status: status)
            )
        return .ok(.init(body: .json(map(result))))
    }
}
