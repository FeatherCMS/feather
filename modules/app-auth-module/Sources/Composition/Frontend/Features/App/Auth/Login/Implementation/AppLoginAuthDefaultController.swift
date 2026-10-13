import FeatherAdmin
import FeatherValidation
import Foundation
import Hummingbird
import WebFrontend

struct AppLoginAuthDefaultController: AppLoginAuthController {
    let usesSecureCookies: Bool
    let turnstileVerifier: (any TurnstileVerifier)?
    let buildRuntime:
        RuntimeBuilder<
            any AppLoginAuthInteractor,
            any AppLoginAuthPresenter
        >

    func getLogin(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime((request, context))
        let redirectPath = request.queryString("redirect") ?? "/"
        return presenter.renderPage(
            form: presenter.formState(
                email: "",
                password: "",
                isPersistent: true,
                redirectPath: redirectPath,
                turnstileSiteKey: turnstileVerifier?.siteKey
            ),
            message: nil
        )
    }

    func postLogin(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        var lastPayload: LoginFormInput?
        do {
            let decoded = try await request.decode(
                as: TurnstileDecoded<LoginFormInput>.self,
                context: context
            )
            let payload = decoded.data
            lastPayload = payload
            try await payload.validate()

            if let turnstileVerifier {
                let isVerified: Bool
                do {
                    isVerified = try await turnstileVerifier.verify(
                        token: decoded.token
                    )
                }
                catch {
                    isVerified = false
                }
                guard isVerified else {
                    return try loginFormErrorResponse(
                        request: request,
                        context: context,
                        presenter: presenter,
                        state: presenter.formState(
                            email: payload.email,
                            password: payload.password,
                            isPersistent: payload.isPersistent.value,
                            redirectPath: request.queryString("redirect")
                                ?? "/",
                            turnstileSiteKey: turnstileVerifier.siteKey
                        ),
                        message:
                            "Please complete the verification and try again."
                    )
                }
            }

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
                secure: usesSecureCookies,
                httpOnly: true,
                sameSite: .lax
            )

            let redirectPath =
                request.queryString("redirect")
                .flatMap { path in
                    guard path.hasPrefix("/"), !path.hasPrefix("//") else {
                        return nil
                    }
                    return path
                } ?? "/"

            return Response(
                status: .seeOther,
                headers: [
                    .location: redirectPath,
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
                email: lastPayload?.email ?? "",
                password: lastPayload?.password ?? "",
                isPersistent: lastPayload?.isPersistent.value ?? true,
                redirectPath: request.queryString("redirect") ?? "/",
                turnstileSiteKey: turnstileVerifier?.siteKey
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
                    email: lastPayload?.email ?? "",
                    password: lastPayload?.password ?? "",
                    isPersistent: lastPayload?.isPersistent.value ?? true,
                    redirectPath: request.queryString("redirect") ?? "/",
                    turnstileSiteKey: turnstileVerifier?.siteKey
                ),
                message: "Incorrect email or password."
            )
        }
    }

    private func loginFormResponse(
        request: Request,
        context: DefaultRequestContext,
        presenter: any AppLoginAuthPresenter,
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
        context: DefaultRequestContext,
        presenter: any AppLoginAuthPresenter,
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
