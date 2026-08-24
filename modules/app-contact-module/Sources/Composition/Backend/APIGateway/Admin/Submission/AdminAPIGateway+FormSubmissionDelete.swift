import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {
    public func contactFormSubmissionDelete(
        _ input: Operations.ContactFormSubmissionDelete.Input
    ) async throws -> Operations.ContactFormSubmissionDelete.Output {
        _ = try await self.useCases.makeDeleteContactFormSubmission()
            .execute(
                subject: try await CurrentSubject.require(),
                input:
                    .init(id: input.path.contactFormSubmissionId)
            )
        return .noContent
    }
}
