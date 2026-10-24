public import ContactAdminAPI
import ContactApplication
import ContactDomain
import FeatherApplication
import FeatherModuleKit
import Foundation

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

    private func map(
        _ value: FormField.List.Output.Item
    ) -> Components.Schemas.FormFieldSchema {
        .init(
            id: value.id,
            key: value.key,
            _type: value.type.rawValue,
            label: value.label,
            allowedValues: value.allowedValues.map(\.value),
            isRequired: value.isRequired,
            position: value.position,
            createdAt: value.createdAt.timeIntervalSince1970,
            updatedAt: value.updatedAt.timeIntervalSince1970
        )
    }
}
