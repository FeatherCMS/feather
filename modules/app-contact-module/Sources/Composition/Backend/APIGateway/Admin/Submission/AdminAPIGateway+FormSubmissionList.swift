import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {
    public func contactFormSubmissionList(
        _ input: Operations.ContactFormSubmissionList.Input
    ) async throws -> Operations.ContactFormSubmissionList.Output {
        let result = try await self.useCases.makeListContactFormSubmissions()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(formId: input.path.contactFormId)
            )
        return .ok(.init(body: .json(result.map(map))))
    }
}
