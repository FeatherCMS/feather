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
                input: .init(formKey: input.path.contactFormKey)
            )
        return .ok(
            .init(
                body: .json(
                    result.map {
                        map($0, formKey: input.path.contactFormKey)
                    }
                )
            )
        )
    }
}
