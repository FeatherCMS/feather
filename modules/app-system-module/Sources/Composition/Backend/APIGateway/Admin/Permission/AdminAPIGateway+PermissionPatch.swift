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
        case name
        case notes
    }

    public func systemPermissionPatch(
        _ input: Operations.SystemPermissionPatch.Input
    ) async throws -> Operations.SystemPermissionPatch.Output {
        let body: Components.Schemas.SystemPermissionPatchSchema
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
        let name = OptionalFieldChange(
            value: body.name,
            shouldApply: fields.contains(.name)
        )
        let notes = OptionalFieldChange(
            value: body.notes,
            shouldApply: fields.contains(.notes)
        )

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeEditPermission()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.systemPermissionId,
                key: key,
                name: name,
                notes: notes
            )
        )

        return .ok(
            .init(
                body: .json(permissionDetailSchema(from: result))
            )
        )
    }

    private func permissionDetailSchema(
        from output: SystemModule.Permission.Edit.Output
    ) -> Components.Schemas.SystemPermissionDetailSchema {
        .init(
            id: output.id,
            key: output.key,
            name: output.name,
            notes: output.notes
        )
    }

}
