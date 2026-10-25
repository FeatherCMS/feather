public import ContactAdminAPI
import ContactApplication
import ContactDomain
import ContactModule
import FeatherApplication
import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Foundation
import Hummingbird

extension AdminAPIGateway {
    private enum UpdateMaskFields: String, Sendable {
        case key
        case type
        case label
        case allowedValues
        case isRequired
        case position
    }

    public func contactFieldPatch(
        _ input: Operations.ContactFieldPatch.Input
    ) async throws -> Operations.ContactFieldPatch.Output {
        let body: Components.Schemas.FormFieldPatchSchema
        switch input.body {
        case .json(let value): body = value
        }
        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            throw HTTPError(.badRequest)
        }

        let key = try FieldChange(
            value: body.key,
            shouldApply: fields.contains(.key),
            onMissing: { HTTPError(.badRequest) }
        )
        let type = try FieldChange(
            value: body._type.flatMap(FormField.Model.ItemType.init(rawValue:)),
            shouldApply: fields.contains(.type),
            onMissing: { HTTPError(.badRequest) }
        )
        let label = try FieldChange(
            value: body.label,
            shouldApply: fields.contains(.label),
            onMissing: { HTTPError(.badRequest) }
        )
        let allowedValues = try FieldChange(
            value: body.allowedValues.map { values in
                values.map { .init(value: $0, label: $0) }
            },
            shouldApply: fields.contains(.allowedValues),
            onMissing: { HTTPError(.badRequest) }
        )
        let isRequired = try FieldChange(
            value: body.isRequired,
            shouldApply: fields.contains(.isRequired),
            onMissing: { HTTPError(.badRequest) }
        )
        let position = try FieldChange(
            value: body.position,
            shouldApply: fields.contains(.position),
            onMissing: { HTTPError(.badRequest) }
        )

        let result = try await self.useCases.makeEditFormField()
            .execute(
                subject: try await CurrentSubject.require(),
                input:
                    .init(
                        id: input.path.formFieldId,
                        formId: nil,
                        key: key,
                        type: type,
                        label: label,
                        allowedValues: allowedValues,
                        isRequired: isRequired,
                        position: position
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
