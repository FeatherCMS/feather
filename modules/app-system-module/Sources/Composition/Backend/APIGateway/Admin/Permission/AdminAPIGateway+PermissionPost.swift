import FeatherModuleKit
public import SystemAdminAPI
import SystemApplication
import SystemModule

extension AdminAPIGateway {

    public func systemPermissionPost(
        _ input: Operations.SystemPermissionPost.Input
    ) async throws -> Operations.SystemPermissionPost.Output {
        let body: Components.Schemas.SystemPermissionCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeAddPermission()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                key: body.key,
                name: body.name,
                notes: body.notes
            )
        )

        return .created(
            .init(
                body: .json(permissionDetailSchema(from: result))
            )
        )
    }

    private func permissionDetailSchema(
        from output: SystemModule.Permission.Add.Output
    ) -> Components.Schemas.SystemPermissionDetailSchema {
        .init(
            id: output.id,
            key: output.key,
            name: output.name,
            notes: output.notes
        )
    }
}
