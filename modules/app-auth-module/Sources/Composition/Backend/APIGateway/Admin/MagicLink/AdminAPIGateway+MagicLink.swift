import AuthAdminAPI
import AuthApplication

extension AdminAPIGateway {

    public func authMagicLink(
        _ input: Operations.AuthMagicLink.Input
    ) async throws -> Operations.AuthMagicLink.Output {
        let body: Components.Schemas.AuthMagicLinkRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeRequestMagicLink()
        _ = try await useCase.execute(
            .init(
                email: body.email,
                isPersistent: body.isPersistent
            )
        )

        return .noContent
    }
}
