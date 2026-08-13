import ContactAdminAPI
import ContactApplication
import ContactDomain
import FeatherApplication
import FeatherContracts
import Hummingbird

extension ContactBackend {
    public func contactFormSubmissionUpdate(
        _ input: Operations.ContactFormSubmissionUpdate.Input
    ) async throws -> Operations.ContactFormSubmissionUpdate.Output {
        let body: Components.Schemas.ContactFormSubmissionPatchSchema
        switch input.body {
        case .json(let value): body = value
        }
        guard let status = Submission.Status(rawValue: body.status)
        else { throw HTTPError(.badRequest) }
        let result = try await self.makeUpdateContactFormSubmission()
            .execute(
                subject: try await CurrentSubject.require(),
                input:
                    .init(
                        id: input.path.contactFormSubmissionId,
                        status: status
                    )
            )
        return .ok(.init(body: .json(map(result))))
    }
}
