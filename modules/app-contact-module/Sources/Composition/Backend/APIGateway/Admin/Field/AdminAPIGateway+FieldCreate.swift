public import ContactAdminAPI
import ContactApplication
import ContactDomain
import ContactModule
import FeatherApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {
    public func contactFieldCreate(
        _ input: Operations.ContactFieldCreate.Input
    ) async throws -> Operations.ContactFieldCreate.Output {
        let body: Components.Schemas.FormFieldCreateSchema
        switch input.body {
        case .json(let value): body = value
        }
        guard let type = FormField.Model.ItemType(rawValue: body._type) else {
            throw FormField.Model.Error.optionsNotAllowed
        }
        let result = try await self.useCases.makeCreateFormField()
            .execute(
                subject: try await CurrentSubject.require(),
                input:
                    .init(
                        formId: nil,
                        key: body.key,
                        type: type,
                        label: body.label,
                        allowedValues: body.allowedValues?
                            .map { .init(value: $0, label: $0) } ?? [],
                        isRequired: body.isRequired ?? false,
                        position: body.position ?? 0
                    )
            )
        return .created(.init(body: .json(map(result))))
    }

    private func map(
        _ value: FormField.Add.Output
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
