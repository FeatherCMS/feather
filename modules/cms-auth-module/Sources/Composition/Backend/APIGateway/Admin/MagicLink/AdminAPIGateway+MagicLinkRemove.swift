public import AuthAdminAPI
import AuthApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func authMagicLinkRemove(
        _ input: Operations.AuthMagicLinkRemove.Input
    ) async throws -> Operations.AuthMagicLinkRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeRemoveMagicLink()

        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }
}
