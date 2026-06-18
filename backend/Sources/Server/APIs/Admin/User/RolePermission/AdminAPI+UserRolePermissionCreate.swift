import AdminOpenAPI
import AuthApplication
import Application

extension AdminAPI {

    func userRolePermissionCreate(
        _ input: Operations.UserRolePermissionCreate.Input
    ) async throws -> Operations.UserRolePermissionCreate.Output {
        let body: Components.Schemas.UserRolePermissionCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.auth.makeAddRolePermission()
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
