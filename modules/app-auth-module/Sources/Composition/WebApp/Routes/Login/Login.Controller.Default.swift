import FeatherValidation
import FeatherWebApp
import FeatherWebShared
import Foundation
import Hummingbird

extension Login.Controller {
    struct Default: Interface {
        let usesSecureCookies: Bool
        let turnstileVerifier: (any TurnstileVerifier)?
        let buildRuntime:
            @Sendable (Request, DefaultRequestContext) -> WebAppRuntime<
                any Login.Interactor.Interface,
                any Login.Presenter.Interface
            >

        func getLogin(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> WebAppHTMLResponse {
            let presenter = buildRuntime(request, context).presenter
            let redirectPath =
                request.uri.queryParameters["redirect"].map(String.init) ?? "/"
            return try presenter.renderPage(
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
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            var lastPayload: Login.Form.Input?
            do {
                let decoded = try await request.decode(
                    as: AuthTurnstileDecoded<Login.Form.Input>.self,
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
                                redirectPath: request.uri
                                    .queryParameters["redirect"]
                                    .map(String.init)
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

                let cookie = Cookie(
                    name: "session_token",
                    value: result.token,
                    expires: result.isPersistent
                        ? Date(timeIntervalSince1970: result.expiresAt)
                        : nil,
                    maxAge: result.isPersistent
                        ? max(
                            0,
                            Int(
                                result.expiresAt
                                    - Date().timeIntervalSince1970
                            )
                        )
                        : nil,
                    path: "/",
                    secure: usesSecureCookies,
                    httpOnly: true,
                    sameSite: .lax
                )

                let redirectPath =
                    request.uri.queryParameters["redirect"].map(String.init)
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
                    redirectPath: request.uri.queryParameters["redirect"]
                        .map(String.init) ?? "/",
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
                        redirectPath: request.uri.queryParameters["redirect"]
                            .map(String.init) ?? "/",
                        turnstileSiteKey: turnstileVerifier?.siteKey
                    ),
                    message: "Incorrect email or password."
                )
            }
        }

        private func loginFormResponse(
            request: Request,
            context: DefaultRequestContext,
            presenter: any Login.Presenter.Interface,
            state: Login.Form.State
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
            presenter: any Login.Presenter.Interface,
            state: Login.Form.State,
            message: String
        ) throws -> Response {
            try presenter.renderPage(
                form: state,
                message: message
            )
            .response(from: request, context: context)
        }
    }
}
