import FeatherModuleKit
public import SystemAdminAPI
import SystemApplication
import SystemModule

extension AdminAPIGateway {

    public func systemPermissionGet(
        _ input: Operations.SystemPermissionGet.Input
    ) async throws -> Operations.SystemPermissionGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeGetPermissions()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.systemPermissionId)
        )

        return .ok(
            .init(
                body: .json(
                    permissionDetailSchema(from: result)
                )
            )
        )
    }

    private func permissionDetailSchema(
        from output: SystemModule.Permission.Detail.Output
    ) -> Components.Schemas.SystemPermissionDetailSchema {
        .init(
            id: output.id,
            key: output.key,
            name: output.name,
            notes: output.notes
        )
    }
}
