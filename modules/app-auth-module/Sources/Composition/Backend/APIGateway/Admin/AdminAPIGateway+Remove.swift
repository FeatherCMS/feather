public import AuthAdminAPI
import AuthApplication
import FeatherModuleKit

extension AdminAPIGateway {
    public func authRolePermissionRemove(
        _ input: Operations.AuthRolePermissionRemove.Input
    ) async throws -> Operations.AuthRolePermissionRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveRolePermission()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }

    public func userIdentitySessionRemove(
        _ input: Operations.UserIdentitySessionRemove.Input
    ) async throws -> Operations.UserIdentitySessionRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let removeSession = useCases.makeRemoveSession()
        _ = try await removeSession.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }
}
