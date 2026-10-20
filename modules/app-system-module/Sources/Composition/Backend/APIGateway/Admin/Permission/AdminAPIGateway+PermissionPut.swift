import FeatherDomain
import FeatherModuleKit
public import SystemAdminAPI
import SystemApplication
import SystemModule

extension AdminAPIGateway {

    public func systemPermissionPut(
        _ input: Operations.SystemPermissionPut.Input
    ) async throws -> Operations.SystemPermissionPut.Output {
        let body: Components.Schemas.SystemPermissionCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeEditPermission()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.systemPermissionId,
                key: .set(body.key),
                name: body.name.map { OptionalFieldChange.set($0) } ?? .clear,
                notes: body.notes.map { OptionalFieldChange.set($0) } ?? .clear
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
