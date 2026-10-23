import AuthModule
import FeatherWebApp
import FeatherWebShared
import Foundation
import Hummingbird

extension MagicLink.App.Controller {
    struct Default: Interface {
        let usesSecureCookies: Bool
        let turnstileVerifier: (any AuthTurnstileVerifier)?
        let routes: MagicLink.App.Router.Routes
        let buildRuntime:
            @Sendable (Request, DefaultRequestContext) -> WebAppRuntime<
                any MagicLink.App.Interactor.Interface,
                any MagicLink.App.Presenter.Interface
            >

        func getRequest(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> WebAppHTMLResponse {
            let presenter = buildRuntime(request, context).presenter
            return try presenter.render(
                email: "",
                isPersistent: true,
                error: nil,
                message: nil,
                turnstileSiteKey: turnstileVerifier?.siteKey,
                routes: routes
            )
        }

        func postRequest(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let decoded = try await request.decode(
                as: AuthTurnstileDecoded<MagicLink.App.Form.Input>.self,
                context: context
            )
            let input = decoded.data

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
                    return
                        try presenter.render(
                            email: input.email,
                            isPersistent: input.isPersistent.value,
                            error:
                                "Please complete the verification and try again.",
                            message: nil,
                            turnstileSiteKey: turnstileVerifier.siteKey,
                            routes: routes
                        )
                        .response(from: request, context: context)
                }
            }

            do {
                try await interactor.request(
                    email: input.email,
                    isPersistent: input.isPersistent.value,
                    context: context
                )
                return
                    try presenter.render(
                        email: input.email,
                        isPersistent: input.isPersistent.value,
                        error: nil,
                        message:
                            "If registered, your sign-in link is on its way.",
                        turnstileSiteKey: turnstileVerifier?.siteKey,
                        routes: routes
                    )
                    .response(from: request, context: context)
            }
            catch let error as OpenAPIRepositoryError {
                return
                    try presenter.render(
                        email: input.email,
                        isPersistent: input.isPersistent.value,
                        error: error.errorDescription,
                        message: nil,
                        turnstileSiteKey: turnstileVerifier?.siteKey,
                        routes: routes
                    )
                    .response(from: request, context: context)
            }
        }

        func verify(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let token =
                request.uri.queryParameters["token"].map(String.init) ?? ""
            do {
                let result = try await interactor.verify(
                    token: token,
                    context: context
                )
                let cookie = Cookie(
                    name: "session_token",
                    value: result.token,
                    path: "/",
                    secure: usesSecureCookies,
                    httpOnly: true,
                    sameSite: .lax
                )
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: routes.home.path,
                        .setCookie: cookie.description,
                    ]
                )
            }
            catch let error as OpenAPIRepositoryError {
                let message: String?
                switch error {
                case .unauthorized:
                    message =
                        "This magic link is invalid, expired, or has already been used."
                default:
                    message = error.errorDescription
                }
                return
                    try presenter.render(
                        email: "",
                        isPersistent: true,
                        error: message,
                        message: nil,
                        turnstileSiteKey: turnstileVerifier?.siteKey,
                        routes: routes
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
