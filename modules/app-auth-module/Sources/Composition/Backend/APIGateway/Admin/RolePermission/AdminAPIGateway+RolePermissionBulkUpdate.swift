public import AuthAdminAPI
import AuthApplication
import AuthModule
import FeatherModuleKit

extension AdminAPIGateway {
    public func authRolePermissionBulkUpdate(
        _ input: Operations.AuthRolePermissionBulkUpdate.Input
    ) async throws -> Operations.AuthRolePermissionBulkUpdate.Output {
        let body: Components.Schemas.AuthRolePermissionBulkUpdateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeBulkUpdateRolePermissions()
        try await useCase.execute(
            subject: subject,
            input: .init(
                additions: body.additions.map {
                    .init(roleId: $0.roleId, permissionId: $0.permissionId)
                },
                removals: body.removals.map {
                    .init(roleId: $0.roleId, permissionId: $0.permissionId)
                }
            )
        )

        return .noContent(.init())
    }
}
