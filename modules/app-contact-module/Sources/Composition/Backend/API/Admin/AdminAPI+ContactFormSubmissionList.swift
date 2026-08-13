import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension ContactBackend {
    public func contactFormSubmissionList(
        _ input: Operations.ContactFormSubmissionList.Input
    ) async throws -> Operations.ContactFormSubmissionList.Output {
        let result = try await self.makeListContactFormSubmissions()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(formId: input.path.contactFormId)
            )
        return .ok(.init(body: .json(result.map(map))))
    }
}
