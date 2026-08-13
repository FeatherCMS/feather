import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension ContactBackend {
    public func contactFieldGet(
        _ input: Operations.ContactFieldGet.Input
    ) async throws -> Operations.ContactFieldGet.Output {
        let result = try await self.makeGetFormField()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(id: input.path.formFieldId, formId: nil)
            )
        return .ok(.init(body: .json(map(result))))
    }
}
