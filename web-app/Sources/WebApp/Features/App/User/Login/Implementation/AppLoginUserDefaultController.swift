import FeatherValidation
import Foundation
import Hummingbird
import SGML

struct AppLoginUserDefaultController: AppLoginUserController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AppLoginUserInteractor,
            presenter: any AppLoginUserPresenter
        )

    func getLogin(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            form: presenter.formState(
                email: "mail.tib@gmail.com",
                password: "root",
                isPersistent: true
            ),
            message: nil
        )
    }

    func postLogin(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        var lastPayload: LoginFormInput?
        do {
            let payload = try await request.decode(
                as: LoginFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()

            let result = try await interactor.execute(
                entity: .init(
                    email: payload.email,
                    password: payload.password,
                    isPersistent: payload.isPersistent.value
                )
            )

            let oneDay: TimeInterval = 60 * 60 * 24
            let cookie = Cookie(
                name: "session_token",
                value: result.token,
                expires: Date().addingTimeInterval(oneDay),
                maxAge: Int(oneDay),
                path: "/",
                secure: AppEnvironmentStore.current.publicOrigins
                    .usesSecureCookies,
                httpOnly: true,
                sameSite: .lax
            )

            return Response(
                status: .seeOther,
                headers: [
                    .location: "/",
                    .setCookie: cookie.description,
                ]
            )
        }
        catch let error as ValidationError {
            var errors: [String: String] = [:]
            for failure in error.failures {
                errors[failure.key] = failure.message
            }

            var state = presenter.formState(
                email: lastPayload?.email ?? "mail.tib@gmail.com",
                password: lastPayload?.password ?? "root",
                isPersistent: lastPayload?.isPersistent.value ?? true
            )
            state.apply(errors: errors)

            return try loginFormResponse(
                request: request,
                context: context,
                presenter: presenter,
                state: state
            )
        }
        catch {
            return try loginFormErrorResponse(
                request: request,
                context: context,
                presenter: presenter,
                state: presenter.formState(
                    email: lastPayload?.email ?? "mail.tib@gmail.com",
                    password: lastPayload?.password ?? "root",
                    isPersistent: lastPayload?.isPersistent.value ?? true
                ),
                message: error.displayMessage
            )
        }
    }

    private func loginFormResponse(
        request: Request,
        context: AppRequestContext,
        presenter: any AppLoginUserPresenter,
        state: LoginForm.State
    ) throws -> Response {
        try presenter.renderPage(
            form: state,
            message: nil
        )
        .response(from: request, context: context)
    }

    private func loginFormErrorResponse(
        request: Request,
        context: AppRequestContext,
        presenter: any AppLoginUserPresenter,
        state: LoginForm.State,
        message: String
    ) throws -> Response {
        try presenter.renderPage(
            form: state,
            message: message
        )
        .response(from: request, context: context)
    }
}
