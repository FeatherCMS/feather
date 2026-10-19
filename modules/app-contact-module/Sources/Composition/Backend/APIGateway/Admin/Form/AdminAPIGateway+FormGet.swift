public import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherModuleKit

extension AdminAPIGateway {
    public func contactFormGet(
        _ input: Operations.ContactFormGet.Input
    ) async throws -> Operations.ContactFormGet.Output {
        let result = try await self.useCases.makeGetContactForm()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(key: input.path.contactFormKey)
            )
        return .ok(.init(body: .json(map(result))))
    }
}
