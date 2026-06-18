import AdminOpenAPI
import AuthApplication
import Application

extension AdminAPI {

    func userRolePermissionDelete(
        _ input: Operations.UserRolePermissionDelete.Input
    ) async throws -> Operations.UserRolePermissionDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.auth.makeRemoveRolePermission()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(
                roleId: input.path.userRoleId,
                permissionId: input.path.systemPermissionId
            )
        )

        return .noContent(.init())
    }
}
