import FeatherModuleKit
public import UserAdminAPI
import UserApplication

extension AdminAPIGateway {

    public func userRoleRemove(
        _ input: Operations.UserRoleRemove.Input
    ) async throws -> Operations.UserRoleRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveRole()

        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }
}
