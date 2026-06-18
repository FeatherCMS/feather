import AppOpenAPI
import Application
import AuthApplication
import AuthDomain
import UserApplication
import UserDomain

extension AppAPI {

    func authRegister(
        _ input: Operations.AuthRegister.Input
    ) async throws -> Operations.AuthRegister.Output {
        let body: Components.Schemas.AuthRegisterSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.user.makeRegisterAccount()
        let account = try await useCase.execute(
            input: UserApplication.RegisterAccount.Input(
                email: body.email,
                password: body.password
            )
        )

        return .created(
            .init(
                body: .json(
                    .init(
                        user: .init(
                            id: account.id,
                            email: account.email
                        ),
                        roles: [],
                        permissions: [],
                        token: ""
                    )
                )
            )
        )
    }

    func authLogin(
        _ input: Operations.AuthLogin.Input
    ) async throws -> Operations.AuthLogin.Output {
        let body: Components.Schemas.AuthLoginRequestSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.auth.makeSignInWithCredentials()

        let result = try await useCase.execute(
            .init(
                object: .init(
                    email: body.email,
                    password: body.password,
                    isPersistent: body.isPersistent
                )
            )
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

    func authLogout(
        _ input: Operations.AuthLogout.Input
    ) async throws -> Operations.AuthLogout.Output {
        guard (try? await CurrentSubject.require()) != nil else {
            return .unauthorized
        }
        return .noContent
    }

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
