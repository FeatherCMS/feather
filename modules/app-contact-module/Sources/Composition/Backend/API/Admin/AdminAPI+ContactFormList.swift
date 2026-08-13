import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension ContactBackend {
    public func contactFormList(
        _ input: Operations.ContactFormList.Input
    ) async throws -> Operations.ContactFormList.Output {
        let result = try await self.makeListContactForms()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init()
            )
        return .ok(.init(body: .json(result.map(map))))
    }
}
