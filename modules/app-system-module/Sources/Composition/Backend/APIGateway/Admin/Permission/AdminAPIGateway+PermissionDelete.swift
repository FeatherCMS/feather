import SystemModule
import FeatherModuleKit
public import SystemAdminAPI
import SystemApplication

extension AdminAPIGateway {

    public func systemPermissionDelete(
        _ input: Operations.SystemPermissionDelete.Input
    ) async throws -> Operations.SystemPermissionDelete.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeRemovePermission()

        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }
}
