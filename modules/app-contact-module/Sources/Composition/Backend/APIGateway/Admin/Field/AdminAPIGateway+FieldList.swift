public import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherModuleKit

extension AdminAPIGateway {
    public func contactFieldList(
        _ input: Operations.ContactFieldList.Input
    ) async throws -> Operations.ContactFieldList.Output {
        let isUnassigned = input.query.form == "__unassigned__"
        let result = try await self.useCases.makeListFormFields()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(
                    formId: nil,
                    formKey: isUnassigned ? nil : input.query.form,
                    isUnassigned: isUnassigned
                )
            )
        return .ok(.init(body: .json(result.items.map(map))))
    }
}
