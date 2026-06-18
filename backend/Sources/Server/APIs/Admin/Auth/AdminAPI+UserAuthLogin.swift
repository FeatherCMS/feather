import AdminOpenAPI
import AuthApplication
// TODO: don't leak domain
import UserDomain
import AuthDomain

extension AdminAPI {

    /*
     curl -i -X 'POST' \
        'http://127.0.0.1:8080/api/v1/admin/user/auth/login' \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '{"email":"mail.tib@gmail.com","password":"root","isPersistent":true}'
    */
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
}
