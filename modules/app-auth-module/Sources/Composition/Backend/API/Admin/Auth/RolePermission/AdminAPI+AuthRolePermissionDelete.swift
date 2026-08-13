import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts

extension AuthBackend {

    public func authRolePermissionDelete(
        _ input: Operations.AuthRolePermissionDelete.Input
    ) async throws -> Operations.AuthRolePermissionDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.makeRemoveRolePermission()
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
