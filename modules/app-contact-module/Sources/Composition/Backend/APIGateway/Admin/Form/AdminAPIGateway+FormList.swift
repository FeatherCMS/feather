public import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherModuleKit

extension AdminAPIGateway {
    public func contactFormList(
        _ input: Operations.ContactFormList.Input
    ) async throws -> Operations.ContactFormList.Output {
        let result = try await self.useCases.makeListContactForms()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init()
            )
        return .ok(.init(body: .json(result.map(map))))
    }
}
