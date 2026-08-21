import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {
    public func contactFormDelete(
        _ input: Operations.ContactFormDelete.Input
    ) async throws -> Operations.ContactFormDelete.Output {
        _ = try await self.useCases.makeDeleteContactForm()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(id: input.path.contactFormId)
            )
        return .noContent
    }
}
