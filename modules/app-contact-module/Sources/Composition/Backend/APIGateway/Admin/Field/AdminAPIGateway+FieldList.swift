public import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherModuleKit

extension AdminAPIGateway {
    public func contactFieldList(
        _ input: Operations.ContactFieldList.Input
    ) async throws -> Operations.ContactFieldList.Output {
        let result = try await self.useCases.makeListFormFields()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(
                    formId: nil,
                    formKey: input.query.form
                )
            )
        return .ok(.init(body: .json(result.map(map))))
    }
}
