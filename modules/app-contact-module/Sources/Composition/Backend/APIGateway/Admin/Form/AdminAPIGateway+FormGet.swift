import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {
    public func contactFormGet(
        _ input: Operations.ContactFormGet.Input
    ) async throws -> Operations.ContactFormGet.Output {
        let result = try await self.useCases.makeGetContactForm()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(id: input.path.contactFormId)
            )
        return .ok(.init(body: .json(map(result))))
    }
}
