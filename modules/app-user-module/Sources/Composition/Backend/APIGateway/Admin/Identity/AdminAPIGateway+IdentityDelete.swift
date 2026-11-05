import FeatherModuleKit
public import UserAdminAPI
import UserApplication

extension AdminAPIGateway {

    public func userIdentityDelete(
        _ input: Operations.UserIdentityDelete.Input
    ) async throws -> Operations.UserIdentityDelete.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveIdentity()

        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }
}
