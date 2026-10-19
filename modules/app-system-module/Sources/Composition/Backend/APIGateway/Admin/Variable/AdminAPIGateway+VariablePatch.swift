import FeatherBackend
import FeatherModuleKit
import FeatherDomain
import Foundation
import Hummingbird
public import SystemAdminAPI
import SystemApplication
import SystemModule

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case key
        case value
        case name
        case notes
    }

    public func systemVariablePatch(
        _ input: Operations.SystemVariablePatch.Input
    ) async throws -> Operations.SystemVariablePatch.Output {
        let body: Components.Schemas.SystemVariablePatchSchema
        switch input.body {
        case .json(let value):
            body = value
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
        let value = try FieldChange(
            value: body.value,
            shouldApply: fields.contains(.value),
            onMissing: { HTTPError(.badRequest) }
        )
        let name = OptionalFieldChange(
            value: body.name,
            shouldApply: fields.contains(.name)
        )
        let notes = OptionalFieldChange(
            value: body.notes,
            shouldApply: fields.contains(.notes)
        )

        let useCase = self.useCases.makeEditVariable()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.systemVariableId,
                key: key,
                value: value,
                name: name,
                notes: notes
            )
        )

        return .ok(
            .init(
                body: .json(variableDetailSchema(from: result))
            )
        )
    }

    private func variableDetailSchema(
        from output: Variable.Edit.Output
    ) -> Components.Schemas.SystemVariableDetailSchema {
        .init(
            id: output.id,
            key: output.key,
            value: output.value,
            name: output.name,
            notes: output.notes
        )
    }

}
