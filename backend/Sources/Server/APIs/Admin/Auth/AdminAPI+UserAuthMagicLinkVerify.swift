import AdminOpenAPI
import AuthApplication
import AuthDomain
import UserDomain

extension AdminAPI {

    func authMagicLinkVerify(
        _ input: Operations.AuthMagicLinkVerify.Input
    ) async throws -> Operations.AuthMagicLinkVerify.Output {
        let body: Components.Schemas.AuthMagicLinkVerifyRequestSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.auth.makeSignInWithMagicLink()
        let result = try await useCase.execute(
            .init(token: body.token)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        user: .init(
                            id: result.user.id,
                            email: result.user.email
                        ),
                        roles: result.roles,
                        permissions: result.permissions,
                        token: result.session.token
                    )
                )
            )
        )
    }
}
