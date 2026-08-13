import AuthAdminAPI
import AuthApplication

extension AuthBackend {

    public func authMagicLink(
        _ input: Operations.AuthMagicLink.Input
    ) async throws -> Operations.AuthMagicLink.Output {
        let body: Components.Schemas.AuthMagicLinkRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.makeRequestMagicLink()
        _ = try await useCase.execute(
            .init(
                email: body.email,
                isPersistent: body.isPersistent
            )
        )

        return .noContent
    }
}
