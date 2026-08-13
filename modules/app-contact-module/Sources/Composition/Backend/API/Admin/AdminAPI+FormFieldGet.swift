import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension ContactBackend {
    public func formFieldGet(
        _ input: Operations.FormFieldGet.Input
    ) async throws -> Operations.FormFieldGet.Output {
        let result = try await self.makeGetFormField()
            .execute(
                subject: try await CurrentSubject.require(),
                input:
                    .init(
                        id: input.path.formFieldId,
                        formId: input.path.contactFormId
                    )
            )
        return .ok(.init(body: .json(map(result))))
    }
}
