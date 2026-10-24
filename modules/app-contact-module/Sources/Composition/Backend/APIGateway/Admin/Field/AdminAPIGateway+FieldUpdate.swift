public import ContactAdminAPI
import ContactApplication
import ContactDomain
import ContactModule
import FeatherApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {
    public func contactFieldUpdate(
        _ input: Operations.ContactFieldUpdate.Input
    ) async throws -> Operations.ContactFieldUpdate.Output {
        let body: Components.Schemas.FormFieldPatchSchema
        switch input.body {
        case .json(let value): body = value
        }
        let result = try await self.useCases.makeUpdateFormField()
            .execute(
                subject: try await CurrentSubject.require(),
                input:
                    .init(
                        id: input.path.formFieldId,
                        formId: nil,
                        key: body.key,
                        type: body._type.flatMap(
                            FormField.Model.ItemType.init(rawValue:)
                        ),
                        label: body.label,
                        allowedValues: body.allowedValues.map {
                            $0.map { .init(value: $0, label: $0) }
                        },
                        isRequired: body.isRequired,
                        position: body.position
                    )
            )
        return .ok(.init(body: .json(map(result))))
    }

    private func map(
        _ value: FormField.Edit.Output
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
