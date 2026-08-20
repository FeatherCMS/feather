import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {
    public func contactFormSubmissionGet(
        _ input: Operations.ContactFormSubmissionGet.Input
    ) async throws -> Operations.ContactFormSubmissionGet.Output {
        let result = try await self.useCases.makeGetContactFormSubmission()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(id: input.path.contactFormSubmissionId)
            )
        return .ok(.init(body: .json(map(result))))
    }
}
