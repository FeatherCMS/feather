import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension ContactBackend {
    public func contactFieldList(
        _ input: Operations.ContactFieldList.Input
    ) async throws -> Operations.ContactFieldList.Output {
        let result = try await self.makeListFormFields()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(formId: nil)
            )
        return .ok(.init(body: .json(result.map(map))))
    }
}
