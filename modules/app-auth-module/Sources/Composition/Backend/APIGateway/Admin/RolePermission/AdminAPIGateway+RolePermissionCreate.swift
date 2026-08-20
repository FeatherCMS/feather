import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func authRolePermissionCreate(
        _ input: Operations.AuthRolePermissionCreate.Input
    ) async throws -> Operations.AuthRolePermissionCreate.Output {
        let body: Components.Schemas.AuthRolePermissionCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeAddRolePermission()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                roleId: body.roleId,
                permissionId: body.permissionId
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
