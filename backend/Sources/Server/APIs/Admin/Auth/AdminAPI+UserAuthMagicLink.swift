import AdminOpenAPI
import AuthApplication

extension AdminAPI {

    func authMagicLink(
        _ input: Operations.AuthMagicLink.Input
    ) async throws -> Operations.AuthMagicLink.Output {
        let body: Components.Schemas.AuthMagicLinkRequestSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.auth.makeRequestMagicLink()
        _ = try await useCase.execute(
            .init(
                email: body.email,
                isPersistent: body.isPersistent
            )
        )

        return .noContent
    }
}
