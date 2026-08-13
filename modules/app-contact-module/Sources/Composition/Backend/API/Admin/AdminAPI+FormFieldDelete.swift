import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension ContactBackend {
    public func formFieldDelete(
        _ input: Operations.FormFieldDelete.Input
    ) async throws -> Operations.FormFieldDelete.Output {
        try await self.makeDeleteFormField()
            .execute(
                subject: try await CurrentSubject.require(),
                input:
                    .init(
                        id: input.path.formFieldId,
                        formId: input.path.contactFormId
                    )
            )
        return .noContent
    }
}
