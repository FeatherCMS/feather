import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension ContactBackend {
    public func contactFormDelete(
        _ input: Operations.ContactFormDelete.Input
    ) async throws -> Operations.ContactFormDelete.Output {
        _ = try await self.makeDeleteContactForm()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(id: input.path.contactFormId)
            )
        return .noContent
    }
}
