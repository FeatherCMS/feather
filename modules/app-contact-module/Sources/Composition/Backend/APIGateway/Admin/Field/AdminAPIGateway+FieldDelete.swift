import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {
    public func contactFieldDelete(
        _ input: Operations.ContactFieldDelete.Input
    ) async throws -> Operations.ContactFieldDelete.Output {
        try await self.useCases.makeDeleteFormField()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(id: input.path.formFieldId, formId: nil)
            )
        return .noContent
    }
}
