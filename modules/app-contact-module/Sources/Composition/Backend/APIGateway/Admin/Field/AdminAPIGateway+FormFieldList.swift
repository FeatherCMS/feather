import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {
    public func formFieldList(
        _ input: Operations.FormFieldList.Input
    ) async throws -> Operations.FormFieldList.Output {
        let result = try await self.useCases.makeListFormFields()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(formId: input.path.contactFormId)
            )
        return .ok(.init(body: .json(result.map(map))))
    }
}
