public import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherModuleKit

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
                    result.items.map {
                        map($0, formKey: input.path.contactFormKey)
                    }
                )
            )
        )
    }
}
